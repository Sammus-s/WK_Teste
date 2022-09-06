unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Data.Win.ADODB, DMConnection, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, system.UITypes, uProdutosPedidos;

type
  TfrmMain = class(TForm)
    pnCampos: TPanel;
    pnGrid: TPanel;
    edtCliente: TLabeledEdit;
    edtNomeCliente: TDBEdit;
    edtDescProduto: TDBEdit;
    gridProdutos: TDBGrid;
    dsVenda: TDataSource;
    btnInserir: TButton;
    edtQtdeProduto: TLabeledEdit;
    edtVlrUniProduto: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    DataSetProdutos: TADODataSet;
    DataSetPedidos: TADODataSet;
    edtProduto: TLabeledEdit;
    lblTotal: TLabel;
    btnGravarVenda: TButton;
    btnCarregaVenda: TButton;
    btnCancelaVenda: TButton;
    procedure FormCreate(Sender: TObject);
    procedure edtClienteChange(Sender: TObject);
    procedure edtProdutoChange(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure CriaDataSet;
    procedure clearProduto;
    procedure clear;
    procedure editProduto;
    procedure deleteProduto;
    procedure gridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DataSetProdutosAfterPost(DataSet: TDataSet);
    procedure btnGravarVendaClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function validaCamposProduto : boolean;
    function validaCampos : boolean;
    procedure btnCarregaVendaClick(Sender: TObject);
    procedure btnCancelaVendaClick(Sender: TObject);
  private
    var
      DM : TDMConnect;
      ProdutoPedido: TProdutosPedidos;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCancelaVendaClick(Sender: TObject);
var LCodigoVenda : integer;
begin
  try
    if (DataSetProdutos.RecordCount > 0) then
      clear;

    LCodigoVenda := StrToIntDef(InputBox('Insira o c�digo', 'N� Pedido', ''), 0);

    if MessageDlg('Deseja deletar essa venda?', mtConfirmation,
    [mbYes, mbNo], 0, mbYes) = mrYes then
    begin
      ProdutoPedido.DeleteVenda(LCodigoVenda);
    end;

  except
    on e:Exception do
    raise Exception.Create('Erro ao Cancelar Venda');
  end;

end;

procedure TfrmMain.btnCarregaVendaClick(Sender: TObject);
var LCodigoVenda : integer;
begin
  try
    if (DataSetProdutos.RecordCount > 0) then
      clear;

    LCodigoVenda := StrToIntDef(InputBox('Insira o c�digo', 'N� Pedido', ''), 0);

    if ProdutoPedido.CarregarVenda(LCodigoVenda, DataSetProdutos) then
    edtCliente.Text := DM.QueryPedido.FieldByName('codigo_cliente').Value;

  except
    on e:Exception do
    raise Exception.Create('Erro ao Carregar Venda');
  end;
end;

procedure TfrmMain.btnGravarVendaClick(Sender: TObject);
begin
  if not validaCampos then
    Exit;

  ProdutoPedido.CodigoCliente := StrToInt(edtCliente.Text);
  ProdutoPedido.GravarVenda(DataSetProdutos);
  clear;
end;

procedure TfrmMain.btnInserirClick(Sender: TObject);
begin
  if not validaCamposProduto then
    exit;

  ProdutoPedido.CodigoProduto := StrToIntDef(edtProduto.text,0);
  ProdutoPedido.descProduto   := edtDescProduto.Text;
  ProdutoPedido.quantidade    := StrToIntDef(edtQtdeProduto.text,0);
  ProdutoPedido.vlr_unitario  := StrToCurr(edtVlrUniProduto.text);
  ProdutoPedido.AddOnDataSet(DataSetProdutos);

  clearProduto;
end;

procedure TfrmMain.btnSalvarClick(Sender: TObject);
begin
  DataSetProdutos.FieldByName('quantidade').value := edtQtdeProduto.Text;
  DataSetProdutos.Fieldbyname('valor_total').AsCurrency := StrToCurr(edtVlrUniProduto.text) * DataSetProdutos.FieldByName('quantidade').Value;
  edtProduto.ReadOnly := false;
  DataSetProdutos.Post;

  btnInserir.Caption := 'Inserir';
  btnInserir.OnClick := self.btnInserirClick;
  btnInserir.Update;

  edtDescProduto.DataSource := DM.DSProdutos;
  edtVlrUniProduto.DataSource := DM.DSProdutos;

  clearProduto;
end;

procedure TfrmMain.clear;
begin
  clearProduto;
  edtCliente.Clear;

  DataSetProdutos.First;
  while not DataSetProdutos.Eof do
  begin
    DataSetProdutos.Delete;
    DataSetProdutos.First;
  end;
end;

procedure TfrmMain.clearProduto;
begin
  edtProduto.Clear;
  edtQtdeProduto.Clear;
  edtProduto.SetFocus;
  edtClienteChange(edtCliente);
end;

procedure TfrmMain.CriaDataSet;
begin
  self.DataSetProdutos.FieldDefs.Clear;
  self.DataSetProdutos.FieldDefs.Add('codigo_produto',ftInteger);
  self.DataSetProdutos.FieldDefs.Add('descricao',ftString,100,false);
  self.DataSetProdutos.FieldDefs.Add('quantidade',ftInteger);
  self.DataSetProdutos.FieldDefs.Add('preco_venda',ftCurrency);
  self.DataSetProdutos.FieldDefs.Add('valor_total',ftCurrency);
  self.DataSetProdutos.CreateDataSet;
  gridProdutos.Columns[1].Width := 300;
end;

procedure TfrmMain.DataSetProdutosAfterPost(DataSet: TDataSet);
begin
  ProdutoPedido.TotalPedido := 0;
  DataSetProdutos.First;

  while not DataSetProdutos.Eof do
  begin
    ProdutoPedido.TotalPedido := ProdutoPedido.TotalPedido + DataSet.FieldByName('valor_total').Value;
    DataSetProdutos.Next;
  end;

  lblTotal.Visible := ProdutoPedido.TotalPedido <> 0;
  lblTotal.Caption := 'Total: ' + CurrToStr(ProdutoPedido.TotalPedido);
end;

procedure TfrmMain.deleteProduto;
begin
  if MessageDlg('Deseja deletar esse produto?',
  mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
  begin
    DataSetProdutos.Delete;
  end;
end;

procedure TfrmMain.editProduto;
begin
  try
    DataSetProdutos.Edit;
    edtDescProduto.DataSource := dsVenda;
    edtVlrUniProduto.DataSource := dsVenda;

    edtProduto.ReadOnly := true;
    edtProduto.Text := DataSetProdutos.FieldByName('codigo_produto').value;
    edtQtdeProduto.Text := DataSetProdutos.FieldByName('quantidade').value;

    btnInserir.Caption := 'Salvar';
    btnInserir.OnClick := self.btnSalvarClick;
    btnInserir.Update;
  except
    on e: exception do
      ShowMessage(e.Message);
  end;
end;

procedure TfrmMain.edtClienteChange(Sender: TObject);
begin
  DM.QueryClientes.SQL.Clear;
  DM.QueryClientes.SQL.Add('select * from clientes where codigo = ' + QuotedStr(edtCliente.Text));
  DM.QueryClientes.ExecSQL;
  DM.QueryClientes.Open;

  btnCarregaVenda.Visible := edtCliente.Text = EmptyStr;
  btnCancelaVenda.Visible := edtCliente.Text = EmptyStr;
end;

procedure TfrmMain.edtProdutoChange(Sender: TObject);
begin
  DM.QueryProdutos.SQL.Clear;
  DM.QueryProdutos.SQL.Add('select * from produtos where codigo = ' + QuotedStr(edtProduto.Text));
  DM.QueryProdutos.ExecSQL;
  DM.QueryProdutos.Open;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DM := TDMConnect.Create(self);
  ProdutoPedido := TProdutosPedidos.Create(DM);
  CriaDataSet;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DM);
  FreeAndNil(ProdutoPedido);
end;

procedure TfrmMain.gridProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vkReturn then
    editProduto;

  if Key = vkDelete then
    deleteProduto;
end;

function TfrmMain.validaCampos: boolean;
begin
  Result := ((edtCliente.Text <> EmptyStr) and
             (DataSetProdutos.RecordCount > 0));
end;

function TfrmMain.validaCamposProduto: boolean;
begin
  Result := ((edtNomeCliente.Text <> EmptyStr) and
             (edtDescProduto.Text <> EmptyStr) and
             (edtQtdeProduto.Text <> EmptyStr))
end;

end.

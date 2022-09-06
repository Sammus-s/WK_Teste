unit DMConnection;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDMConnect = class(TDataModule)
    Connect: TADOConnection;
    QueryProdutos: TADOQuery;
    DSProdutos: TDataSource;
    DSClientes: TDataSource;
    QueryClientes: TADOQuery;
    QueryPedido: TADOQuery;
    QueryProdutosPedidos: TADOQuery;
    QueryProdutosdescricao: TStringField;
    QueryProdutospreco_venda: TFloatField;
    QueryClientescodigo: TAutoIncField;
    QueryClientesnome: TStringField;
    QueryClientescidade: TStringField;
    QueryClientesUF: TStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMConnect: TDMConnect;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMConnect.DataModuleCreate(Sender: TObject);
begin
   Connect.Connected := True;
end;

end.

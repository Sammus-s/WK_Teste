unit uPedidos;

interface
uses System.SysUtils, DMConnection;

type TPedidos = class
  private
    FNumeroPedido : integer;
    FDataEmissao : TDate;
    FCodigoCliente : integer;
    FTotalPedido : Currency;
  public
    constructor Create(ADM : TDMConnect);
    property NumeroPedido  : integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao   : TDate read FDataEmissao write FDataEmissao;
    property CodigoCliente : integer read FCodigoCliente write FCodigoCliente;
    property TotalPedido   : Currency read FTotalPedido write FTotalPedido;

end;

implementation

{ Clientes }

constructor TPedidos.Create(ADM : TDMConnect);
begin
  numeroPedido := 0;
  DataEmissao := Date();
  CodigoCliente := 0;
  TotalPedido := 0;
end;

end.

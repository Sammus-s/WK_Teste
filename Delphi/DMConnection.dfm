object DMConnect: TDMConnect
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 244
  Width = 524
  object Connect: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=MSOLEDBSQL;Persist Security Info=False;User ID=sa;Initi' +
      'al Catalog=WK_Teste;Data Source=(local);Initial File Name="";Ser' +
      'ver SPN="";Authentication="";Access Token=""'
    Provider = 'MSOLEDBSQL.1'
    Left = 48
    Top = 48
  end
  object QueryProdutos: TADOQuery
    AutoCalcFields = False
    Connection = Connect
    CursorType = ctStatic
    Parameters = <>
    Left = 224
    Top = 64
    object QueryProdutosdescricao: TStringField
      FieldName = 'descricao'
      Size = 100
    end
    object QueryProdutospreco_venda: TFloatField
      FieldName = 'preco_venda'
    end
  end
  object DSProdutos: TDataSource
    DataSet = QueryProdutos
    Left = 224
    Top = 128
  end
  object DSClientes: TDataSource
    DataSet = QueryClientes
    Left = 136
    Top = 128
  end
  object QueryClientes: TADOQuery
    AutoCalcFields = False
    Connection = Connect
    CursorType = ctStatic
    Parameters = <>
    Left = 136
    Top = 67
    object QueryClientescodigo: TAutoIncField
      FieldName = 'codigo'
      ReadOnly = True
    end
    object QueryClientesnome: TStringField
      FieldName = 'nome'
      Size = 100
    end
    object QueryClientescidade: TStringField
      FieldName = 'cidade'
      Size = 100
    end
    object QueryClientesUF: TStringField
      FieldName = 'UF'
      FixedChar = True
      Size = 2
    end
  end
  object QueryPedido: TADOQuery
    AutoCalcFields = False
    Connection = Connect
    CursorType = ctStatic
    Parameters = <>
    Left = 304
    Top = 64
  end
  object QueryProdutosPedidos: TADOQuery
    AutoCalcFields = False
    Connection = Connect
    CursorType = ctStatic
    Parameters = <>
    Left = 400
    Top = 64
  end
end

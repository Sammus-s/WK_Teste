CREATE DATABASE WK_Teste;
USE WK_Teste;
CREATE TABLE clientes(codigo int IDENTITY(1,1) primary key not null,
					  nome varchar(100),
					  cidade varchar(100),
					  UF char(2));
				  
CREATE TABLE produtos(codigo int IDENTITY(1,1) primary key not null,
					  descricao varchar(100),
					  preco_venda float(2));		
					  
CREATE TABLE pedidos(numero_pedido int IDENTITY(1,1) primary key not null,
					 data_emissao date default GETDATE(),
					 codigo_cliente int foreign key references clientes(codigo),
					 total float(2));					  

CREATE TABLE pedidos_produtos(autoincrem int IDENTITY(1,1) primary key not null,
							  numero_pedido int foreign key references pedidos(numero_pedido) ON DELETE CASCADE,
							  codigo_produto int foreign key references produtos(codigo),
							  quantidade int,
							  vlr_unitario float(2),
							  total float(2));

INSERT INTO produtos VALUES ('Descrição produto 1', 26.25);
INSERT INTO produtos VALUES ('Descrição produto 2', 20.25);
INSERT INTO produtos VALUES ('Descrição produto 3', 6.25);
INSERT INTO produtos VALUES ('Descrição produto 4', 35.50);
INSERT INTO produtos VALUES ('Descrição produto 5', 39.99);
INSERT INTO produtos VALUES ('Descrição produto 6', 6.0);
INSERT INTO produtos VALUES ('Descrição produto 7', 28.50);
INSERT INTO produtos VALUES ('Descrição produto 8', 36.50);
INSERT INTO produtos VALUES ('Descrição produto 9', 27.25);
INSERT INTO produtos VALUES ('Descrição produto 10', 40.50);
INSERT INTO produtos VALUES ('Descrição produto 11', 33.99);
INSERT INTO produtos VALUES ('Descrição produto 12', 11.99);
INSERT INTO produtos VALUES ('Descrição produto 13', 5.50);
INSERT INTO produtos VALUES ('Descrição produto 14', 12.0);
INSERT INTO produtos VALUES ('Descrição produto 15', 11.25);
INSERT INTO produtos VALUES ('Descrição produto 16', 7.0);
INSERT INTO produtos VALUES ('Descrição produto 17', 41.0);
INSERT INTO produtos VALUES ('Descrição produto 18', 38.75);
INSERT INTO produtos VALUES ('Descrição produto 19', 31.0);
INSERT INTO produtos VALUES ('Descrição produto 20', 47.50);

INSERT INTO clientes VALUES ('cliente 1', 'Cascavél', 'PR');
INSERT INTO clientes VALUES ('cliente 2', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 3', 'Cascavél', 'PR');
INSERT INTO clientes VALUES ('cliente 4', 'São Paulo', 'SP');
INSERT INTO clientes VALUES ('cliente 5', 'Curitiba', 'PR');
INSERT INTO clientes VALUES ('cliente 6', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 7', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 8', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 9', 'Curitiba', 'PR');
INSERT INTO clientes VALUES ('cliente 10', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 11', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 12', 'São Paulo', 'SP');
INSERT INTO clientes VALUES ('cliente 13', 'Curitiba', 'PR');
INSERT INTO clientes VALUES ('cliente 14', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 15', 'Pato Branco', 'PR');
INSERT INTO clientes VALUES ('cliente 16', 'São Paulo', 'SP');
INSERT INTO clientes VALUES ('cliente 17', 'Chopinzinho', 'PR');
INSERT INTO clientes VALUES ('cliente 18', 'Curitiba', 'PR');
INSERT INTO clientes VALUES ('cliente 19', 'Chopinzinho', 'PR');
INSERT INTO clientes VALUES ('cliente 20', 'Cascavél', 'PR');
GO

CREATE TRIGGER OnDeletePedidos 
   ON  pedidos
   FOR DELETE
AS 
BEGIN
	DECLARE
	@CodigoPedido INT;

	select @CodigoPedido = d.numero_pedido from deleted d

	delete from pedidos_produtos where numero_pedido = @CodigoPedido;

END;
GO
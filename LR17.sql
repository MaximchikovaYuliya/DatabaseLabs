use M_UNIVER;
go

--1
select [TEACHER].TEACHER[TEACHER], [TEACHER].TEACHER_NAME[TEACHER_NAME], [TEACHER].GENDER[GENDER], [TEACHER].PULPIT[PULPIT]
	from TEACHER[TEACHER] where [TEACHER].PULPIT = '����' 
		for XML PATH('TEACHER'), root('ISIT_TEACHERS'), elements;
go

--2
select AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
	from AUDITORIUM where AUDITORIUM_TYPE = '��' 
		for XML AUTO, root('LK_AUDITORIUM'), elements;
go

--3
declare @h int = 0,
	@x nvarchar(2000) = N'<?xml version="1.0" encoding="UTF-16"?>
	<SUBJECTS>
	<SUBJECT SUBJECT="hhh" SUBJECT_NAME="fewfe" PULPIT="����"/>
	<SUBJECT SUBJECT="h" SUBJECT_NAME="fyjt" PULPIT="����"/>
	<SUBJECT SUBJECT="hh" SUBJECT_NAME="fhtrhrt" PULPIT="����"/>
	</SUBJECTS>';
exec sp_xml_preparedocument @h output, @x;

insert SUBJECT select [SUBJECT], [SUBJECT_NAME], [PULPIT]
	from openxml(@h, '/SUBJECTS/SUBJECT',0)
		with ([SUBJECT] char(10), [SUBJECT_NAME]varchar(100), [PULPIT]char(20));
go

--4
insert into STUDENT(IDGROUP,NAME,BDAY,STAMP,INFO)
	values(6,'������ ���� ���������', GETDATE(), default,'<�����>  <������>��������</������>
	           <�����>�����</�����>  <�����>������</�����>
	           <���>52</���>    </�����>');
select NAME, INFO.value('(/�����/������)[1]','varchar(10)') [������], INFO.query('/�����') [�����] from STUDENT;
go

--5
create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="�������">  
       <xs:complexType><xs:sequence>
       <xs:element name="�������" maxOccurs="1" minOccurs="1">
       <xs:complexType>
       <xs:attribute name="�����" type="xs:string" use="required" />
       <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
       <xs:attribute name="����"  use="required" >  
       <xs:simpleType>  <xs:restriction base ="xs:string">
   <xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
   </xs:restriction> 	</xs:simpleType>
   </xs:attribute> </xs:complexType> 
   </xs:element>
   <xs:element maxOccurs="3" name="�������" type="xs:unsignedInt"/>
   <xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
   </xs:sequence></xs:complexType>  </xs:element>
   </xs:sequence></xs:complexType>
   </xs:element>
</xs:schema>';
go

alter table STUDENT
alter column INFO xml(Student);

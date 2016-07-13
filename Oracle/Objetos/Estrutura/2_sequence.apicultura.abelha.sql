begin
   execute immediate 'create sequence apicultura.sqe_abe nocache';
exception
   when others then
      if sqlcode not in (-955) then
         raise;
      end if;
end;
/
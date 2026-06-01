/*
Purpose:    近源模型层-往年数据迁移表空间，此脚本由手工生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd dqc_iol_move_tablespace
CreateDate: 20210720
FileType:   DML
Logs:
            
*/
set timing on
set serveroutput on 

declare

	v_del_dt             varchar2(4)             :=null;
	v_sql                varchar2(1000)          :=null; 

begin
    v_del_dt := to_char(to_date(${batch_date},'yyyymmdd'),'yyyy')-1;
	
	for tb in (select tab_en_name from dqc.move_table_type_info where belong_levl = 'IML' and run_type = '1') loop
	        
		    for i in (select subpartition_name
			            from all_tab_subpartitions
			           where table_name = upper(tb.tab_en_name)
			             and substr(subpartition_name,-8,4) <= v_del_dt
			             and table_owner = 'IML') loop	
						 
			      v_sql := 'alter table iml.' || tb.tab_en_name || ' move subpartition ' || i.subpartition_name || ' compress for query high tablespace tbs_ndw_xthis update global indexes';
			      --dbms_output.put_line(v_sql);
			      --dbms_output.put_line(i.subpartition_name);
			      execute immediate v_sql;
			
		    end loop;
			
  end loop;
	
end;
/

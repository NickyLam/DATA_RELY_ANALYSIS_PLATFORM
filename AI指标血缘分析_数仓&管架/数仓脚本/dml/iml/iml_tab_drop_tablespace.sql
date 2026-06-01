/*
Purpose:    整合模型层-删除表空分区，此脚本由手工生成。
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
	v_drop_sql           varchar2(1000)          :=null;
	v_flag               number(10)              :=0;

begin
    v_del_dt := to_char(to_date(${batch_date},'yyyymmdd'),'yyyy')-1;
	
	for tb in (select tab_en_name from dqc.move_table_type_info where belong_levl = 'IML' and run_type = '2') loop
	        
		    for i in (select substr(subpartition_name,-8,8) as par_date,subpartition_name
			              from all_tab_subpartitions
			             where table_name = upper(tb.tab_en_name)
			               and substr(subpartition_name,-8,4) <= v_del_dt
			               and table_owner = 'IML'
			               and substr(subpartition_name,-8,8) <> '19000101') loop	

						v_sql := 'select count(*) from ' || tb.tab_en_name || ' where to_date('|| i.par_date||',''yyyy-mm-dd'') = etl_dt';
						execute immediate v_sql into v_flag;

						if v_flag = 0 then
						    
			          v_drop_sql := 'alter table iml.' || tb.tab_en_name || ' drop subpartition ' || i.subpartition_name;
			          execute immediate v_drop_sql;
			          --dbms_output.put_line(tb.tab_en_name || '  ' || i.par_date || '  ' || i.subpartition_name || '  ' || v_flag);
			          --dbms_output.put_line(v_drop_sql);
			          
			      end if;

		    end loop;
			
  end loop;
	
end;
/

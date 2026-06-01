/*
Purpose:    整全模型层-公共代码自动同步
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220630 iml_ref_pub_cd_autosyn
CreateDate: 20221023
Logs:       20221023 曹永茂 新建脚本
            20230531 曹永茂 1. 调整算法，只做码值新增和更新，不做删除；
                            2. 同时支持一个代码同步来自多个来源表的码值;
                            3. 删除ref_curr_cd币种代码表的重复无效数据；
                            4. 删除ref_cty_rg_cd国家和地区代码表的重复无效数据；
                            5. 删除ref_dist_cd行政区划代码表重复无效数据；
                            6. 删除ref_indus_type_cd国家和地区代码表重复无效数据.
            
*/

set timing on
--开并发
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

--更新分区
whenever sqlerror continue none;
alter table ${iml_schema}.ref_pub_cd_his drop partition p_${batch_date};
alter table ${iml_schema}.ref_pub_cd_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));


--删除临时表
whenever sqlerror continue none;
drop table ${iml_schema}.ref_pub_cd_tmp1 purge;

--更新前备份数据
create table ${iml_schema}.ref_pub_cd_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_pub_cd 
where 1=1
;

--创建临时表
create table ${iml_schema}.ref_pub_cd_tmp1
nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_pub_cd where 0=1;


--删除配置表的重复数据
delete from iml.ref_pub_cd_autosyn_config
 where rowid in (select rowid
                   from (select t.*,
                                row_number() over(partition by cd_id,valid_flg,src_table_en_name order by update_dt desc) rn
                           from iml.ref_pub_cd_autosyn_config t) tt
                  where tt.rn <> 1)
;
commit;

--执行SQL语句
--whenever sqlerror continue none;
whenever sqlerror exit sql.sqlcode;
set serveroutput on
declare
  v_insert_sql1        varchar2(2000);
  v_contitions_1       varchar2(1000);    
  v_select_sql1        varchar2(4000);    
  v_select_sql2        varchar2(4000);   
  v_select_sql3        varchar2(4000);    
  v_sql_txt            varchar2(4000);
  v_error_sql          varchar2(4000);  
  v_parent_field_name  varchar2(100);  
  v_quote_data_std     varchar2(100);  

begin
  for tb in (select  * from iml.ref_pub_cd_autosyn_config t where t.valid_flg='Y'
 ) loop
   begin 
   
   dbms_output.enable(buffer_size=>null);   

--插入语句   
   v_insert_sql1 := 'insert into iml.ref_pub_cd_tmp1(
                        cd_id
                        ,cd_tab_en_name
                        ,cd_tab_cn_descb
                        ,cd_val
                        ,cd_descb
                        ,parent_cd
                        ,valid_flg
                        ,invalid_dt
                        ,data_std_flg
                        ,quote_data_std
                        ,remark
                        ,etl_dt
                        ,src_table_name
                        ,job_cd
                        ,etl_timestamp) ' ;
   
   --dbms_output.put_line(v_insert_sql1);

--过滤条件1
   if upper(tb.table_type) = 'ST'  then 
       v_contitions_1 := ' start_dt <= to_date(''' || ${batch_date} || ''', ''yyyymmdd'') and end_dt > to_date(' || ${batch_date} || ', ''yyyymmdd'')'; 

   elsif upper(tb.table_type) = 'SN'  then 
       v_contitions_1 := ' create_dt <= to_date(''' || ${batch_date} || ''', ''yyyymmdd'') and id_mark <> ''D'''; 
      
   else
       v_contitions_1 := ' etl_dt = to_date(''' || ${batch_date} || ''', ''yyyymmdd'')';  
                         
   end if;
   
-- 子查询SQL          
   v_select_sql1 := '(select t.*, row_number() over(partition by ' || tb.src_cd_field_en_name || ' order by 1 desc) rn 
                     from ' || tb.src_sys_cd || '.' || tb.src_table_en_name || ' t 
                     where 1=1'  || tb.spec_cond || '
                     and ' || v_contitions_1 || ')';                                               

-- 父级代码
   if trim(tb.src_parent_field_en_name) is null then 
       v_parent_field_name := ''' ''';
   else
       v_parent_field_name := tb.src_parent_field_en_name;  
   end if;

-- 引用的数标代码
   if trim(tb.quote_data_std) is null then 
       v_quote_data_std := ''' ''';
   else
       v_quote_data_std := tb.quote_data_std;  
   end if;
         
-- 查询新增码值   
   v_select_sql2 := 'select  
                        ''' || tb.cd_id ||'''               
                       ,''' || tb.cd_tab_en_name ||'''
                       ,''' || tb.cd_tab_cn_descb ||'''
                       ,' || tb.src_cd_field_en_name || '
                       ,' || tb.src_descb_field_en_name ||'
                       ,' || v_parent_field_name || '
                       ,''Y''
                       ,to_date(''29991231'',''yyyymmdd'')
                       ,''' || tb.data_std_flg || '''
                       ,' || v_quote_data_std || '
                       ,''自动同步码值''
                       , to_date(''' || ${batch_date} || ''',''yyyymmdd'')  
                       ,''' || tb.src_table_en_name ||'''
                       ,''sdt''
                       ,systimestamp
                    from iml.ref_pub_cd t1
                    right join ' || v_select_sql1 || ' t2
                    on t1.cd_val=t2.' || tb.src_cd_field_en_name || '
                    and t2.rn=1
                    and t1.cd_id = ''' || tb.cd_id || '''
                    where t1.cd_val is null'
                   ;                     
   
   --dbms_output.put_line(v_select_sql2);

-- 查询更新
   v_select_sql3 := 'select  
                        t1.cd_id
                       ,t1.cd_tab_en_name
                       ,t1.cd_tab_cn_descb
                       ,t1.cd_val
                       ,nvl(trim(t2.' || tb.src_descb_field_en_name || '), t1.cd_descb)
                       ,' || v_parent_field_name || '
                       ,case when ''' || tb.cd_id || ''' is null then t1.valid_flg 
                             else  
                                 case when ' || tb.src_descb_field_en_name || ' is null then t1.valid_flg else ''Y'' end
                        end          
                       ,case when ''' || tb.cd_id || ''' is null then t1.invalid_dt 
                             else 
                                 case when ' || tb.src_descb_field_en_name || ' is null  then  t1.invalid_dt  else to_date(''29991231'',''yyyymmdd'') end
                        end
                       ,''' || tb.data_std_flg || '''
                       ,t1.quote_data_std
                       ,case when ' || tb.src_descb_field_en_name || ' is null then t1.remark else ''自动同步码值'' end
                       ,case when t2.' || tb.src_descb_field_en_name || ' is null  or t2.' || tb.src_descb_field_en_name || '= t1.cd_descb then t1.etl_dt else  to_date(''' || ${batch_date} || ''', ''yyyymmdd'')  end
                       ,case when t2.' || tb.src_descb_field_en_name || ' is null  or t2.' || tb.src_descb_field_en_name || '= t1.cd_descb then t1.src_table_name else ''' || tb.src_table_en_name ||''' end
                       ,''sdt''
                       ,case when t2.' || tb.src_descb_field_en_name || ' is null  or t2.' || tb.src_descb_field_en_name || '= t1.cd_descb then t1.etl_timestamp else systimestamp end
                    from iml.ref_pub_cd t1
                    left join ' || v_select_sql1 || ' t2
                    on t1.cd_val=t2.' || tb.src_cd_field_en_name || '
                    and t2.rn=1
                    where t1.cd_id = ''' || tb.cd_id ||''''
                    ;   
 
    --dbms_output.put_line(v_select_sql3);                  

-- 插入新增码值   
   v_sql_txt := v_insert_sql1 || v_select_sql2; 
   --dbms_output.put_line(v_sql_txt);
   execute immediate v_sql_txt;
   commit;

-- 插入更新码值   
   v_sql_txt := v_insert_sql1 || v_select_sql3; 
   --dbms_output.put_line(v_sql_txt);
   execute immediate v_sql_txt;
   commit;
   

--异常处理   
   exception
      when others then      
        v_error_sql := 'error msg：' || sqlerrm || ' : ' || tb.cd_id || ' - ' || tb.src_table_en_name;       
        dbms_output.put_line(v_error_sql);                            

        null;
        
   end;  
 end loop;
  
  commit;
  
  if trim(v_error_sql) is null then
        --清空代码表
       -- truncate table iml.ref_pub_cd;
        delete from ${iml_schema}.ref_pub_cd where 1=1;
        commit;
        
        --插入新增和更新的数据
        insert into ${iml_schema}.ref_pub_cd(
             cd_id
            ,cd_tab_en_name
            ,cd_tab_cn_descb
            ,cd_val
            ,cd_descb
            ,parent_cd
            ,valid_flg
            ,invalid_dt
            ,data_std_flg
            ,quote_data_std
            ,remark
            ,etl_dt
            ,src_table_name
            ,job_cd
            ,etl_timestamp) 
        select 
            cd_id
            ,cd_tab_en_name
            ,cd_tab_cn_descb
            ,cd_val
            ,cd_descb
            ,parent_cd
            ,valid_flg
            ,case when invalid_dt is null and valid_flg = 'Y' then to_date('29991231','yyyymmdd')
                  when invalid_dt is null and valid_flg <> 'Y' then to_date('${batch_date}','yyyymmdd')
                  when invalid_dt = to_date('29991231','yyyymmdd') and valid_flg <> 'Y' then to_date('${batch_date}','yyyymmdd')
                  else invalid_dt end
            ,data_std_flg
            ,quote_data_std
            ,remark
            ,to_date('${batch_date}','yyyymmdd')
            ,src_table_name
            ,job_cd
            ,etl_timestamp
        from ${iml_schema}.ref_pub_cd_tmp1
        where 1=1
        ;
        commit;
        
        --回插没有更新的数据
        insert into ${iml_schema}.ref_pub_cd(
            cd_id
            ,cd_tab_en_name
            ,cd_tab_cn_descb
            ,cd_val
            ,cd_descb
            ,parent_cd
            ,valid_flg
            ,invalid_dt
            ,data_std_flg
            ,quote_data_std
            ,remark
            ,etl_dt
            ,src_table_name
            ,job_cd
            ,etl_timestamp) 
        select 
             t1.cd_id
            ,t1.cd_tab_en_name
            ,t1.cd_tab_cn_descb
            ,t1.cd_val
            ,t1.cd_descb
            ,t1.parent_cd
            ,t1.valid_flg
            ,case when t1.invalid_dt is null and t1.valid_flg = 'Y' then to_date('29991231','yyyymmdd')
                  when t1.invalid_dt is null and t1.valid_flg <> 'Y' then to_date('${batch_date}','yyyymmdd')
                  when t1.invalid_dt = to_date('29991231','yyyymmdd') and t1.valid_flg <> 'Y' then to_date('${batch_date}','yyyymmdd')
                  else t1.invalid_dt end
            ,t1.data_std_flg
            ,t1.quote_data_std
            ,' '
            ,to_date('${batch_date}','yyyymmdd')
            ,t1.src_table_name
            ,t1.job_cd
            ,t1.etl_timestamp
        from ${iml_schema}.ref_pub_cd_bk t1
        left join ${iml_schema}.ref_pub_cd_tmp1 t2
        on t1.cd_id=t2.cd_id
        where t2.cd_id is null
        ;
        commit;
   end if;   
       

commit; 
--异常处理   
   exception
      when others then     
        v_error_sql := 'error msg：' || sqlerrm ;           
        dbms_output.put_line(v_error_sql);      
end;
/


--备份进历史表
whenever sqlerror exit sql.sqlcode;
insert into iml.ref_pub_cd_his(
    cd_id
    ,cd_tab_en_name
    ,cd_tab_cn_descb
    ,cd_val
    ,cd_descb
    ,parent_cd
    ,valid_flg
    ,invalid_dt
    ,data_std_flg
    ,quote_data_std
    ,remark
    ,etl_dt
    ,src_table_name
    ,job_cd
    ,etl_timestamp) 
select 
    cd_id
    ,cd_tab_en_name
    ,cd_tab_cn_descb
    ,cd_val
    ,cd_descb
    ,parent_cd
    ,valid_flg
    ,invalid_dt
    ,data_std_flg
    ,quote_data_std
    ,remark
    ,to_date('${batch_date}','yyyymmdd') as etl_dt
    ,src_table_name
    ,job_cd
    ,etl_timestamp
from iml.ref_pub_cd_bk
where 1=1
;
commit;

--删除公共代码表重复数据
delete from iml.ref_pub_cd
 where rowid in (select rowid
                   from (select t.*,
                                row_number() over(partition by cd_id, cd_val order by valid_flg desc, etl_timestamp desc) rn
                           from iml.ref_pub_cd t) tt
                  where tt.rn <> 1)
;
commit;    

--删除临时表
whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_pub_cd_bk purge;


---------------------其他码表的重复无效数据处理-----------------------

--删除临时表
whenever sqlerror continue none;
drop table ${iml_schema}.ref_curr_cd_bk purge;
drop table ${iml_schema}.ref_cty_rg_cd_bk purge;
drop table ${iml_schema}.ref_dist_cd_bk purge;
drop table ${iml_schema}.ref_indus_type_cd_bk purge;


whenever sqlerror exit sql.sqlcode;
--备份重复数据
create table ${iml_schema}.ref_curr_cd_bk nologging
compress ${option_switch} for query high
as
select *
  from (select t.*,
               row_number() over(partition by cd_val order by valid_flg desc, etl_timestamp desc) rn
          from iml.ref_curr_cd t) tt
 where tt.rn <> 1
;

create table ${iml_schema}.ref_cty_rg_cd_bk nologging
compress ${option_switch} for query high
as
select *
  from (select t.*,
               row_number() over(partition by cd_val order by valid_flg desc, etl_timestamp desc) rn
          from iml.ref_cty_rg_cd t) tt
 where tt.rn <> 1
;

create table ${iml_schema}.ref_dist_cd_bk nologging
compress ${option_switch} for query high
as
select *
  from (select t.*,
               row_number() over(partition by rg_cd, city_cd, prov_cd order by valid_flg desc, etl_timestamp desc) rn
          from iml.ref_dist_cd t) tt
 where tt.rn <> 1
;

create table ${iml_schema}.ref_indus_type_cd_bk nologging
compress ${option_switch} for query high
as
select *
  from (select t.*,
               row_number() over(partition by indus_type_cd order by valid_flg desc, etl_timestamp desc) rn
          from iml.ref_indus_type_cd t) tt
 where tt.rn <> 1
;

--删除币种代码表重复数据
delete from iml.ref_curr_cd
 where rowid in (select rowid
                   from (select t.*,
                                row_number() over(partition by cd_val order by valid_flg desc, etl_timestamp desc) rn
                           from iml.ref_curr_cd t) tt
                  where tt.rn <> 1)
;
commit; 
              
--删除国家和地区代码表重复数据
delete from iml.ref_cty_rg_cd
 where rowid in (select rowid
                   from (select t.*,
                                row_number() over(partition by cd_val order by valid_flg desc, etl_timestamp desc) rn
                           from iml.ref_cty_rg_cd t) tt
                  where tt.rn <> 1)
;
commit; 

--删除行政区划代码表重复数据
delete from iml.ref_dist_cd
 where rowid in (select rowid
                   from (select t.*,
                                row_number() over(partition by rg_cd,city_cd,prov_cd order by valid_flg desc, etl_timestamp desc) rn
                           from iml.ref_dist_cd t) tt
                  where tt.rn <> 1)
;
commit; 

--删除行业类型代码表重复数据
delete from iml.ref_indus_type_cd
 where rowid in (select rowid
                   from (select t.*,
                                row_number() over(partition by indus_type_cd order by valid_flg desc, etl_timestamp desc) rn
                           from iml.ref_indus_type_cd t) tt
                  where tt.rn <> 1)
;
commit; 





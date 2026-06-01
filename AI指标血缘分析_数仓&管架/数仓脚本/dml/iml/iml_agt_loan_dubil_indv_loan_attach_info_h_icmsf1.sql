/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_dubil_indv_loan_attach_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,white_list_cust_flg -- 白户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,farm_flg -- 农户标志
    ,cust_char_cd -- 客户性质代码
    ,cust_crdt_tot_amt -- 客户授信总额度
    ,move_flg -- 迁移标志
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,corp_cred_dubil_id -- 企业级客户借据编号
    ,cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,tax_flg -- 涉税标志
    ,agclt_flg -- 涉农标志
    ,file_int_accr_flg -- 靠档计息标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bd_personal_loan-1
insert into ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,white_list_cust_flg -- 白户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,farm_flg -- 农户标志
    ,cust_char_cd -- 客户性质代码
    ,cust_crdt_tot_amt -- 客户授信总额度
    ,move_flg -- 迁移标志
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,corp_cred_dubil_id -- 企业级客户借据编号
    ,cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,tax_flg -- 涉税标志
    ,agclt_flg -- 涉农标志
    ,file_int_accr_flg -- 靠档计息标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300004'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 借据编号
    ,NVL(TRIM(P1.ISWHITE),'-') -- 白户标志
    ,P1.BALLOONAMORTENDDATE -- 气球贷摊销到期日期
    ,NVL(TRIM(P1.ISFARMER),'-') -- 农户标志
    ,NVL(TRIM(P1.INDTYPE),'-') -- 客户性质代码
    ,0 -- 客户授信总额度
    ,P1.MIGTFLAG -- 迁移标志
    ,nvl(trim(P1.PRODUCTCHANNEL),'0000') -- 产品渠道标识代码
    ,P1.ENTCLAIMSERIALNO -- 企业级债权通知书编号
    ,P1.ENTCLAIMIMAGEINFONO -- 企业级客户借据编号
    ,P1.RETAILCLAIMSERIALNO -- 客户级债权通知书编号
    ,nvl(trim(P1.TAXFLG),'-') -- 涉税标志
    ,nvl(trim(P1.ISAGRICULTURE),'-') -- 涉农标志
    ,nvl(trim(P1.ISBELONGTERM),'-') -- 靠档计息标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bd_personal_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bd_personal_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,white_list_cust_flg -- 白户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,farm_flg -- 农户标志
    ,cust_char_cd -- 客户性质代码
    ,cust_crdt_tot_amt -- 客户授信总额度
    ,move_flg -- 迁移标志
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,corp_cred_dubil_id -- 企业级客户借据编号
    ,cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,tax_flg -- 涉税标志
    ,agclt_flg -- 涉农标志
    ,file_int_accr_flg -- 靠档计息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,white_list_cust_flg -- 白户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,farm_flg -- 农户标志
    ,cust_char_cd -- 客户性质代码
    ,cust_crdt_tot_amt -- 客户授信总额度
    ,move_flg -- 迁移标志
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,corp_cred_dubil_id -- 企业级客户借据编号
    ,cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,tax_flg -- 涉税标志
    ,agclt_flg -- 涉农标志
    ,file_int_accr_flg -- 靠档计息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.white_list_cust_flg, o.white_list_cust_flg) as white_list_cust_flg -- 白户标志
    ,nvl(n.blon_loan_amort_exp_dt, o.blon_loan_amort_exp_dt) as blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,nvl(n.farm_flg, o.farm_flg) as farm_flg -- 农户标志
    ,nvl(n.cust_char_cd, o.cust_char_cd) as cust_char_cd -- 客户性质代码
    ,nvl(n.cust_crdt_tot_amt, o.cust_crdt_tot_amt) as cust_crdt_tot_amt -- 客户授信总额度
    ,nvl(n.move_flg, o.move_flg) as move_flg -- 迁移标志
    ,nvl(n.prod_chn_idf_cd, o.prod_chn_idf_cd) as prod_chn_idf_cd -- 产品渠道标识代码
    ,nvl(n.corp_cred_rht_advise_id, o.corp_cred_rht_advise_id) as corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,nvl(n.corp_cred_dubil_id, o.corp_cred_dubil_id) as corp_cred_dubil_id -- 企业级客户借据编号
    ,nvl(n.cust_cred_rht_advise_id, o.cust_cred_rht_advise_id) as cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,nvl(n.tax_flg, o.tax_flg) as tax_flg -- 涉税标志
    ,nvl(n.agclt_flg, o.agclt_flg) as agclt_flg -- 涉农标志
    ,nvl(n.file_int_accr_flg, o.file_int_accr_flg) as file_int_accr_flg -- 靠档计息标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
    )
    or (
        o.white_list_cust_flg <> n.white_list_cust_flg
        or o.blon_loan_amort_exp_dt <> n.blon_loan_amort_exp_dt
        or o.farm_flg <> n.farm_flg
        or o.cust_char_cd <> n.cust_char_cd
        or o.cust_crdt_tot_amt <> n.cust_crdt_tot_amt
        or o.move_flg <> n.move_flg
        or o.prod_chn_idf_cd <> n.prod_chn_idf_cd
        or o.corp_cred_rht_advise_id <> n.corp_cred_rht_advise_id
        or o.corp_cred_dubil_id <> n.corp_cred_dubil_id
        or o.cust_cred_rht_advise_id <> n.cust_cred_rht_advise_id
        or o.tax_flg <> n.tax_flg
        or o.agclt_flg <> n.agclt_flg
        or o.file_int_accr_flg <> n.file_int_accr_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,white_list_cust_flg -- 白户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,farm_flg -- 农户标志
    ,cust_char_cd -- 客户性质代码
    ,cust_crdt_tot_amt -- 客户授信总额度
    ,move_flg -- 迁移标志
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,corp_cred_dubil_id -- 企业级客户借据编号
    ,cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,tax_flg -- 涉税标志
    ,agclt_flg -- 涉农标志
    ,file_int_accr_flg -- 靠档计息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,white_list_cust_flg -- 白户标志
    ,blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,farm_flg -- 农户标志
    ,cust_char_cd -- 客户性质代码
    ,cust_crdt_tot_amt -- 客户授信总额度
    ,move_flg -- 迁移标志
    ,prod_chn_idf_cd -- 产品渠道标识代码
    ,corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,corp_cred_dubil_id -- 企业级客户借据编号
    ,cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,tax_flg -- 涉税标志
    ,agclt_flg -- 涉农标志
    ,file_int_accr_flg -- 靠档计息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.dubil_id -- 借据编号
    ,o.white_list_cust_flg -- 白户标志
    ,o.blon_loan_amort_exp_dt -- 气球贷摊销到期日期
    ,o.farm_flg -- 农户标志
    ,o.cust_char_cd -- 客户性质代码
    ,o.cust_crdt_tot_amt -- 客户授信总额度
    ,o.move_flg -- 迁移标志
    ,o.prod_chn_idf_cd -- 产品渠道标识代码
    ,o.corp_cred_rht_advise_id -- 企业级债权通知书编号
    ,o.corp_cred_dubil_id -- 企业级客户借据编号
    ,o.cust_cred_rht_advise_id -- 客户级债权通知书编号
    ,o.tax_flg -- 涉税标志
    ,o.agclt_flg -- 涉农标志
    ,o.file_int_accr_flg -- 靠档计息标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_dubil_indv_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_dubil_indv_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_dubil_indv_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

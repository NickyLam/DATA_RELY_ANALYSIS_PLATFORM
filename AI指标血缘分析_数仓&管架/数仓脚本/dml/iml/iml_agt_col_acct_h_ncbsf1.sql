/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_col_acct_h_ncbsf1
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
alter table ${iml_schema}.agt_col_acct_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_col_acct_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_acct_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_col_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_col_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_col_acct_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_col_acct_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_seq_num -- 交易序号
    ,ova_flow_num -- 全局流水号
    ,col_id -- 押品编号
    ,col_type_cd -- 押品类型代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,col_amt -- 押品金额
    ,remark -- 备注
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,prod_id -- 产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_acct_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_col_acct_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_acct_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_col_acct_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_col_acct_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_collat_info
insert into ${iml_schema}.agt_col_acct_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_seq_num -- 交易序号
    ,ova_flow_num -- 全局流水号
    ,col_id -- 押品编号
    ,col_type_cd -- 押品类型代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,col_amt -- 押品金额
    ,remark -- 备注
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,prod_id -- 产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BRANCH -- 机构编号
    ,nvl(trim(P1.CCY),'0000') -- 币种代码
    ,P1.TRAN_SEQ_NO -- 交易序号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.COLLAT_NO -- 押品编号
    ,P1.COLLAT_TYPE -- 押品类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAYMENT_DIRECTION END -- 收付标识代码
    ,P1.REGISTER_TYPE -- 押品登记簿类型代码
    ,P1.COLLAT_AMOUNT -- 押品金额
    ,P1.REMARK -- 备注
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.PROD_TYPE -- 产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_collat_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_collat_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on p1.PAYMENT_DIRECTION = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_CL_COLLAT_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'PAYMENT_DIRECTION'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_COL_ACCT_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACPT_PAY_IDF_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_col_acct_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_col_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_seq_num -- 交易序号
    ,ova_flow_num -- 全局流水号
    ,col_id -- 押品编号
    ,col_type_cd -- 押品类型代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,col_amt -- 押品金额
    ,remark -- 备注
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,prod_id -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_col_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_seq_num -- 交易序号
    ,ova_flow_num -- 全局流水号
    ,col_id -- 押品编号
    ,col_type_cd -- 押品类型代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,col_amt -- 押品金额
    ,remark -- 备注
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,prod_id -- 产品编号
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tran_seq_num, o.tran_seq_num) as tran_seq_num -- 交易序号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.col_type_cd, o.col_type_cd) as col_type_cd -- 押品类型代码
    ,nvl(n.acpt_pay_idf_cd, o.acpt_pay_idf_cd) as acpt_pay_idf_cd -- 收付标识代码
    ,nvl(n.col_rgst_b_type_cd, o.col_rgst_b_type_cd) as col_rgst_b_type_cd -- 押品登记簿类型代码
    ,nvl(n.col_amt, o.col_amt) as col_amt -- 押品金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_col_acct_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_col_acct_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.org_id <> n.org_id
        or o.curr_cd <> n.curr_cd
        or o.tran_seq_num <> n.tran_seq_num
        or o.ova_flow_num <> n.ova_flow_num
        or o.col_id <> n.col_id
        or o.col_type_cd <> n.col_type_cd
        or o.acpt_pay_idf_cd <> n.acpt_pay_idf_cd
        or o.col_rgst_b_type_cd <> n.col_rgst_b_type_cd
        or o.col_amt <> n.col_amt
        or o.remark <> n.remark
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.prod_id <> n.prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_col_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_seq_num -- 交易序号
    ,ova_flow_num -- 全局流水号
    ,col_id -- 押品编号
    ,col_type_cd -- 押品类型代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,col_amt -- 押品金额
    ,remark -- 备注
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,prod_id -- 产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_col_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,org_id -- 机构编号
    ,curr_cd -- 币种代码
    ,tran_seq_num -- 交易序号
    ,ova_flow_num -- 全局流水号
    ,col_id -- 押品编号
    ,col_type_cd -- 押品类型代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,col_rgst_b_type_cd -- 押品登记簿类型代码
    ,col_amt -- 押品金额
    ,remark -- 备注
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,prod_id -- 产品编号
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
    ,o.acct_id -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.org_id -- 机构编号
    ,o.curr_cd -- 币种代码
    ,o.tran_seq_num -- 交易序号
    ,o.ova_flow_num -- 全局流水号
    ,o.col_id -- 押品编号
    ,o.col_type_cd -- 押品类型代码
    ,o.acpt_pay_idf_cd -- 收付标识代码
    ,o.col_rgst_b_type_cd -- 押品登记簿类型代码
    ,o.col_amt -- 押品金额
    ,o.remark -- 备注
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.prod_id -- 产品编号
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
from ${iml_schema}.agt_col_acct_h_ncbsf1_bk o
    left join ${iml_schema}.agt_col_acct_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_col_acct_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_col_acct_h;
--alter table ${iml_schema}.agt_col_acct_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_col_acct_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_col_acct_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_col_acct_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_col_acct_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_col_acct_h_ncbsf1_cl;
alter table ${iml_schema}.agt_col_acct_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_col_acct_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_col_acct_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_col_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_col_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_col_acct_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_col_acct_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_col_acct_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_tps_margin_acct_h_mpcsi1
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
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_tps_margin_acct_h add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tps_margin_acct_h partition for ('mpcsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_tm purge;
drop table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_op purge;
drop table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,bank_acct_id -- 银行账户编号
    ,open_dt -- 开户日期
    ,broker_cd -- 券商代码
    ,secu_cap_acct_id -- 证券资金账户编号
    ,asset_bal -- 资产余额
    ,margin_status -- 保证金状态
    ,rgst_dt -- 登记日期
    ,std_prod_id -- 标准产品编号
    ,cust_name -- 客户名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tps_margin_acct_h partition for ('mpcsi1')
where 0=1
;

create table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tps_margin_acct_h partition for ('mpcsi1') where 0=1;

create table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tps_margin_acct_h partition for ('mpcsi1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a35tsecbal-
insert into ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,bank_acct_id -- 银行账户编号
    ,open_dt -- 开户日期
    ,broker_cd -- 券商代码
    ,secu_cap_acct_id -- 证券资金账户编号
    ,asset_bal -- 资产余额
    ,margin_status -- 保证金状态
    ,rgst_dt -- 登记日期
    ,std_prod_id -- 标准产品编号
    ,cust_name -- 客户名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130017'||P1.SECCD||P1.CAPITALACCTNO||P1.TRNDT -- 协议编号
    ,'9999' -- 法人编号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.IDTYPE END -- 证件类型代码
    ,P1.IDNO -- 证件号码
    ,P1.ACCTNO -- 银行账户编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPDATE) -- 开户日期
    ,P1.SECCD -- 券商代码
    ,P1.CAPITALACCTNO -- 证券资金账户编号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.SECBAL, '[0-9.]+')),0)) -- 资产余额
    ,P1.STATUS -- 保证金状态
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRNDT) -- 登记日期
    ,'502990101 ' -- 标准产品编号
    ,P1.CUSTNAME -- 客户名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a35tsecbal' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a35tsecbal p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.IDTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A35TSECBAL'
        AND R3.SRC_FIELD_EN_NAME= 'IDTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_TPS_MARGIN_ACCT_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where  1 = 1 
    and P1.TRNDT = '${batch_date}'
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_op(
        agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,bank_acct_id -- 银行账户编号
    ,open_dt -- 开户日期
    ,broker_cd -- 券商代码
    ,secu_cap_acct_id -- 证券资金账户编号
    ,asset_bal -- 资产余额
    ,margin_status -- 保证金状态
    ,rgst_dt -- 登记日期
    ,std_prod_id -- 标准产品编号
    ,cust_name -- 客户名称
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.agt_id -- 协议编号
    ,n.lp_id -- 法人编号
    ,n.cert_type_cd -- 证件类型代码
    ,n.cert_no -- 证件号码
    ,n.bank_acct_id -- 银行账户编号
    ,n.open_dt -- 开户日期
    ,n.broker_cd -- 券商代码
    ,n.secu_cap_acct_id -- 证券资金账户编号
    ,n.asset_bal -- 资产余额
    ,n.margin_status -- 保证金状态
    ,n.rgst_dt -- 登记日期
    ,n.std_prod_id -- 标准产品编号
    ,n.cust_name -- 客户名称
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'mpcsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_tm n
    left join ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.bank_acct_id <> n.bank_acct_id
        or o.open_dt <> n.open_dt
        or o.broker_cd <> n.broker_cd
        or o.secu_cap_acct_id <> n.secu_cap_acct_id
        or o.asset_bal <> n.asset_bal
        or o.margin_status <> n.margin_status
        or o.rgst_dt <> n.rgst_dt
        or o.std_prod_id <> n.std_prod_id
        or o.cust_name <> n.cust_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,bank_acct_id -- 银行账户编号
    ,open_dt -- 开户日期
    ,broker_cd -- 券商代码
    ,secu_cap_acct_id -- 证券资金账户编号
    ,asset_bal -- 资产余额
    ,margin_status -- 保证金状态
    ,rgst_dt -- 登记日期
    ,std_prod_id -- 标准产品编号
    ,cust_name -- 客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,bank_acct_id -- 银行账户编号
    ,open_dt -- 开户日期
    ,broker_cd -- 券商代码
    ,secu_cap_acct_id -- 证券资金账户编号
    ,asset_bal -- 资产余额
    ,margin_status -- 保证金状态
    ,rgst_dt -- 登记日期
    ,std_prod_id -- 标准产品编号
    ,cust_name -- 客户名称
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
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.bank_acct_id -- 银行账户编号
    ,o.open_dt -- 开户日期
    ,o.broker_cd -- 券商代码
    ,o.secu_cap_acct_id -- 证券资金账户编号
    ,o.asset_bal -- 资产余额
    ,o.margin_status -- 保证金状态
    ,o.rgst_dt -- 登记日期
    ,o.std_prod_id -- 标准产品编号
    ,o.cust_name -- 客户名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_bk o
    left join ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 rebuild partition
whenever sqlerror continue none;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_tps_margin_acct_h') 
               and substr(subpartition_name,1,8)=upper('p_mpcsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_tps_margin_acct_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_tps_margin_acct_h modify partition p_mpcsi1 
add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.agt_tps_margin_acct_h exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_cl;
alter table ${iml_schema}.agt_tps_margin_acct_h exchange subpartition p_mpcsi1_20991231 with table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_tps_margin_acct_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_tm purge;
drop table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_op purge;
drop table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_tps_margin_acct_h_mpcsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_tps_margin_acct_h', partname => 'p_mpcsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

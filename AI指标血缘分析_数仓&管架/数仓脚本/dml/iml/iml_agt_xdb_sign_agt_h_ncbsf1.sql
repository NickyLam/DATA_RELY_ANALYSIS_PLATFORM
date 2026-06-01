/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_xdb_sign_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_xdb_sign_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_xdb_sign_agt_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,xdb_prod_id -- 协定宝产品编号
    ,prod_retnd_amt -- 产品留存金额
    ,tran_dt -- 交易日期
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,sign_amt -- 签约金额
    ,cancel_dt -- 取消日期
    ,cancel_teller_id -- 取消柜员编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,auto_renew_flg -- 自动续约标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_xdb_sign_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_xdb_sign_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_xdb_sign_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_xdb-1
insert into ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,xdb_prod_id -- 协定宝产品编号
    ,prod_retnd_amt -- 产品留存金额
    ,tran_dt -- 交易日期
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,sign_amt -- 签约金额
    ,cancel_dt -- 取消日期
    ,cancel_teller_id -- 取消柜员编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,auto_renew_flg -- 自动续约标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,'9999' -- 法人编号
    ,P1.SEQ_NO -- 序号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.PROD_TYPE -- 账户产品编号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 账户子账号
    ,P1.XDB_PROD_TYPE -- 协定宝产品编号
    ,P1.KEEP_AMT -- 产品留存金额
    ,P1.TRAN_DATE -- 交易日期
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.START_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,NVL(TRIM(P1.TERM),0) -- 存期期限
    ,P1.TERM_TYPE -- 期限类型代码
    ,P1.SIGN_AMT -- 签约金额
    ,P1.CANCEL_DATE -- 取消日期
    ,P1.CANCEL_USER_ID -- 取消柜员编号
    ,P1.AGREEMENT_STATUS -- 签约协议状态代码
    ,P1.CLIENT_NO -- 客户编号
    ,DECODE(P1.AUTO_SIGN,'Y','1','N','0') -- 自动续约标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_xdb' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_xdb p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,dep_agt_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,xdb_prod_id -- 协定宝产品编号
    ,prod_retnd_amt -- 产品留存金额
    ,tran_dt -- 交易日期
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,sign_amt -- 签约金额
    ,cancel_dt -- 取消日期
    ,cancel_teller_id -- 取消柜员编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,auto_renew_flg -- 自动续约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,xdb_prod_id -- 协定宝产品编号
    ,prod_retnd_amt -- 产品留存金额
    ,tran_dt -- 交易日期
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,sign_amt -- 签约金额
    ,cancel_dt -- 取消日期
    ,cancel_teller_id -- 取消柜员编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,auto_renew_flg -- 自动续约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.dep_agt_id, o.dep_agt_id) as dep_agt_id -- 存款协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.acct_prod_id, o.acct_prod_id) as acct_prod_id -- 账户产品编号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.acct_sub_acct_num, o.acct_sub_acct_num) as acct_sub_acct_num -- 账户子账号
    ,nvl(n.xdb_prod_id, o.xdb_prod_id) as xdb_prod_id -- 协定宝产品编号
    ,nvl(n.prod_retnd_amt, o.prod_retnd_amt) as prod_retnd_amt -- 产品留存金额
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.dep_term_tenor, o.dep_term_tenor) as dep_term_tenor -- 存期期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.sign_amt, o.sign_amt) as sign_amt -- 签约金额
    ,nvl(n.cancel_dt, o.cancel_dt) as cancel_dt -- 取消日期
    ,nvl(n.cancel_teller_id, o.cancel_teller_id) as cancel_teller_id -- 取消柜员编号
    ,nvl(n.sign_agt_status_cd, o.sign_agt_status_cd) as sign_agt_status_cd -- 签约协议状态代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.auto_renew_flg, o.auto_renew_flg) as auto_renew_flg -- 自动续约标志
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.dep_agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.dep_agt_id = n.dep_agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.dep_agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.dep_agt_id is null
        and n.lp_id is null
    )
    or (
        o.seq_num <> n.seq_num
        or o.acct_id <> n.acct_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.acct_prod_id <> n.acct_prod_id
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.acct_sub_acct_num <> n.acct_sub_acct_num
        or o.xdb_prod_id <> n.xdb_prod_id
        or o.prod_retnd_amt <> n.prod_retnd_amt
        or o.tran_dt <> n.tran_dt
        or o.chn_id <> n.chn_id
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.dep_term_tenor <> n.dep_term_tenor
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.sign_amt <> n.sign_amt
        or o.cancel_dt <> n.cancel_dt
        or o.cancel_teller_id <> n.cancel_teller_id
        or o.sign_agt_status_cd <> n.sign_agt_status_cd
        or o.cust_id <> n.cust_id
        or o.auto_renew_flg <> n.auto_renew_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,xdb_prod_id -- 协定宝产品编号
    ,prod_retnd_amt -- 产品留存金额
    ,tran_dt -- 交易日期
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,sign_amt -- 签约金额
    ,cancel_dt -- 取消日期
    ,cancel_teller_id -- 取消柜员编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,auto_renew_flg -- 自动续约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,dep_agt_id -- 存款协议编号
    ,lp_id -- 法人编号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,acct_prod_id -- 账户产品编号
    ,acct_curr_cd -- 账户币种代码
    ,acct_sub_acct_num -- 账户子账号
    ,xdb_prod_id -- 协定宝产品编号
    ,prod_retnd_amt -- 产品留存金额
    ,tran_dt -- 交易日期
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,dep_term_tenor -- 存期期限
    ,tenor_type_cd -- 期限类型代码
    ,sign_amt -- 签约金额
    ,cancel_dt -- 取消日期
    ,cancel_teller_id -- 取消柜员编号
    ,sign_agt_status_cd -- 签约协议状态代码
    ,cust_id -- 客户编号
    ,auto_renew_flg -- 自动续约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.dep_agt_id -- 存款协议编号
    ,o.lp_id -- 法人编号
    ,o.seq_num -- 序号
    ,o.acct_id -- 账户编号
    ,o.cust_acct_num -- 客户账号
    ,o.acct_prod_id -- 账户产品编号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.acct_sub_acct_num -- 账户子账号
    ,o.xdb_prod_id -- 协定宝产品编号
    ,o.prod_retnd_amt -- 产品留存金额
    ,o.tran_dt -- 交易日期
    ,o.chn_id -- 渠道编号
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.dep_term_tenor -- 存期期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.sign_amt -- 签约金额
    ,o.cancel_dt -- 取消日期
    ,o.cancel_teller_id -- 取消柜员编号
    ,o.sign_agt_status_cd -- 签约协议状态代码
    ,o.cust_id -- 客户编号
    ,o.auto_renew_flg -- 自动续约标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.dep_agt_id = n.dep_agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.dep_agt_id = d.dep_agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_xdb_sign_agt_h;
alter table ${iml_schema}.agt_xdb_sign_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_xdb_sign_agt_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_xdb_sign_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_xdb_sign_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_xdb_sign_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_xdb_sign_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

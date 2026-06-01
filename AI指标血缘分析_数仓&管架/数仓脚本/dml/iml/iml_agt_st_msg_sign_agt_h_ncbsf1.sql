/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_st_msg_sign_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_st_msg_sign_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_st_msg_sign_agt_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,phone -- 联系电话
    ,sign_lev_cd -- 签约级别代码
    ,st_msg_open_three_idf -- 短信开通三位标识符
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,cert_exp_dt -- 证件到期日期
    ,gender_cd -- 性别代码
    ,postn_cd -- 职位代码
    ,acct_id -- 账户编号
    ,st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,tran_in_min_amt -- 转入最小金额
    ,tran_out_min_amt -- 转出最小金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 费用金额
    ,charge_freq_cd -- 收费频率代码
    ,next_charge_dt -- 下一收费日期
    ,charge_dt -- 收费日
    ,charge_cust_acct_num -- 收费客户账号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_st_msg_sign_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_st_msg_sign_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_st_msg_sign_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_sms-1
insert into ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,phone -- 联系电话
    ,sign_lev_cd -- 签约级别代码
    ,st_msg_open_three_idf -- 短信开通三位标识符
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,cert_exp_dt -- 证件到期日期
    ,gender_cd -- 性别代码
    ,postn_cd -- 职位代码
    ,acct_id -- 账户编号
    ,st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,tran_in_min_amt -- 转入最小金额
    ,tran_out_min_amt -- 转出最小金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 费用金额
    ,charge_freq_cd -- 收费频率代码
    ,next_charge_dt -- 下一收费日期
    ,charge_dt -- 收费日
    ,charge_cust_acct_num -- 收费客户账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_ID -- 存款协议编号
    ,P1.CONTACT_TEL -- 联系电话
    ,P1.AGREEMENT_LEVEL -- 签约级别代码
    ,P1.SMS_OPEN_FLAG -- 短信开通三位标识符
    ,P1.CLIENT_NO -- 客户编号
    ,P1.DOCUMENT_ID -- 证件号码
    ,P1.DOCUMENT_TYPE -- 证件类型代码
    ,P1.CH_CLIENT_NAME -- 客户中文名称
    ,P1.DOCUMENT_EXPIRY_DATE -- 证件到期日期
    ,P1.GENDER_FLAG -- 性别代码
    ,P1.POSITION -- 职位代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CASH_MIN_AMT -- 短信发送最小现金金额
    ,P1.TRAN_MIN_AMT -- 短信发送最小转账金额
    ,P1.TAKE_IN_SIGN_CASH -- 转入最小金额
    ,P1.TAKE_OUT_SIGN -- 转出最小金额
    ,P1.FEE_TYPE -- 费用类型编号
    ,P1.FEE_AMT -- 费用金额
    ,P1.CHARGE_PERIOD_FREQ -- 收费频率代码
    ,P1.NEXT_CHARGE_DATE -- 下一收费日期
    ,P1.CHARGE_DAY -- 收费日
    ,P1.CHARGE_TO_BASE_ACCT_NO -- 收费客户账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_sms' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_sms p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dep_agt_id
  	                                        ,phone
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
        into ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,phone -- 联系电话
    ,sign_lev_cd -- 签约级别代码
    ,st_msg_open_three_idf -- 短信开通三位标识符
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,cert_exp_dt -- 证件到期日期
    ,gender_cd -- 性别代码
    ,postn_cd -- 职位代码
    ,acct_id -- 账户编号
    ,st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,tran_in_min_amt -- 转入最小金额
    ,tran_out_min_amt -- 转出最小金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 费用金额
    ,charge_freq_cd -- 收费频率代码
    ,next_charge_dt -- 下一收费日期
    ,charge_dt -- 收费日
    ,charge_cust_acct_num -- 收费客户账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,phone -- 联系电话
    ,sign_lev_cd -- 签约级别代码
    ,st_msg_open_three_idf -- 短信开通三位标识符
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,cert_exp_dt -- 证件到期日期
    ,gender_cd -- 性别代码
    ,postn_cd -- 职位代码
    ,acct_id -- 账户编号
    ,st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,tran_in_min_amt -- 转入最小金额
    ,tran_out_min_amt -- 转出最小金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 费用金额
    ,charge_freq_cd -- 收费频率代码
    ,next_charge_dt -- 下一收费日期
    ,charge_dt -- 收费日
    ,charge_cust_acct_num -- 收费客户账号
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
    ,nvl(n.dep_agt_id, o.dep_agt_id) as dep_agt_id -- 存款协议编号
    ,nvl(n.phone, o.phone) as phone -- 联系电话
    ,nvl(n.sign_lev_cd, o.sign_lev_cd) as sign_lev_cd -- 签约级别代码
    ,nvl(n.st_msg_open_three_idf, o.st_msg_open_three_idf) as st_msg_open_three_idf -- 短信开通三位标识符
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cust_cn_name, o.cust_cn_name) as cust_cn_name -- 客户中文名称
    ,nvl(n.cert_exp_dt, o.cert_exp_dt) as cert_exp_dt -- 证件到期日期
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.postn_cd, o.postn_cd) as postn_cd -- 职位代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.st_msg_send_min_cash_amt, o.st_msg_send_min_cash_amt) as st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,nvl(n.st_msg_send_min_tran_acct_amt, o.st_msg_send_min_tran_acct_amt) as st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,nvl(n.tran_in_min_amt, o.tran_in_min_amt) as tran_in_min_amt -- 转入最小金额
    ,nvl(n.tran_out_min_amt, o.tran_out_min_amt) as tran_out_min_amt -- 转出最小金额
    ,nvl(n.fee_type_id, o.fee_type_id) as fee_type_id -- 费用类型编号
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 费用金额
    ,nvl(n.charge_freq_cd, o.charge_freq_cd) as charge_freq_cd -- 收费频率代码
    ,nvl(n.next_charge_dt, o.next_charge_dt) as next_charge_dt -- 下一收费日期
    ,nvl(n.charge_dt, o.charge_dt) as charge_dt -- 收费日
    ,nvl(n.charge_cust_acct_num, o.charge_cust_acct_num) as charge_cust_acct_num -- 收费客户账号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.phone is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.phone is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dep_agt_id is null
            and n.phone is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
            and o.phone = n.phone
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dep_agt_id is null
        and o.phone is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dep_agt_id is null
        and n.phone is null
    )
    or (
        o.sign_lev_cd <> n.sign_lev_cd
        or o.st_msg_open_three_idf <> n.st_msg_open_three_idf
        or o.cust_id <> n.cust_id
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.cust_cn_name <> n.cust_cn_name
        or o.cert_exp_dt <> n.cert_exp_dt
        or o.gender_cd <> n.gender_cd
        or o.postn_cd <> n.postn_cd
        or o.acct_id <> n.acct_id
        or o.st_msg_send_min_cash_amt <> n.st_msg_send_min_cash_amt
        or o.st_msg_send_min_tran_acct_amt <> n.st_msg_send_min_tran_acct_amt
        or o.tran_in_min_amt <> n.tran_in_min_amt
        or o.tran_out_min_amt <> n.tran_out_min_amt
        or o.fee_type_id <> n.fee_type_id
        or o.fee_amt <> n.fee_amt
        or o.charge_freq_cd <> n.charge_freq_cd
        or o.next_charge_dt <> n.next_charge_dt
        or o.charge_dt <> n.charge_dt
        or o.charge_cust_acct_num <> n.charge_cust_acct_num
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,phone -- 联系电话
    ,sign_lev_cd -- 签约级别代码
    ,st_msg_open_three_idf -- 短信开通三位标识符
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,cert_exp_dt -- 证件到期日期
    ,gender_cd -- 性别代码
    ,postn_cd -- 职位代码
    ,acct_id -- 账户编号
    ,st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,tran_in_min_amt -- 转入最小金额
    ,tran_out_min_amt -- 转出最小金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 费用金额
    ,charge_freq_cd -- 收费频率代码
    ,next_charge_dt -- 下一收费日期
    ,charge_dt -- 收费日
    ,charge_cust_acct_num -- 收费客户账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dep_agt_id -- 存款协议编号
    ,phone -- 联系电话
    ,sign_lev_cd -- 签约级别代码
    ,st_msg_open_three_idf -- 短信开通三位标识符
    ,cust_id -- 客户编号
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,cust_cn_name -- 客户中文名称
    ,cert_exp_dt -- 证件到期日期
    ,gender_cd -- 性别代码
    ,postn_cd -- 职位代码
    ,acct_id -- 账户编号
    ,st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,tran_in_min_amt -- 转入最小金额
    ,tran_out_min_amt -- 转出最小金额
    ,fee_type_id -- 费用类型编号
    ,fee_amt -- 费用金额
    ,charge_freq_cd -- 收费频率代码
    ,next_charge_dt -- 下一收费日期
    ,charge_dt -- 收费日
    ,charge_cust_acct_num -- 收费客户账号
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
    ,o.dep_agt_id -- 存款协议编号
    ,o.phone -- 联系电话
    ,o.sign_lev_cd -- 签约级别代码
    ,o.st_msg_open_three_idf -- 短信开通三位标识符
    ,o.cust_id -- 客户编号
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cust_cn_name -- 客户中文名称
    ,o.cert_exp_dt -- 证件到期日期
    ,o.gender_cd -- 性别代码
    ,o.postn_cd -- 职位代码
    ,o.acct_id -- 账户编号
    ,o.st_msg_send_min_cash_amt -- 短信发送最小现金金额
    ,o.st_msg_send_min_tran_acct_amt -- 短信发送最小转账金额
    ,o.tran_in_min_amt -- 转入最小金额
    ,o.tran_out_min_amt -- 转出最小金额
    ,o.fee_type_id -- 费用类型编号
    ,o.fee_amt -- 费用金额
    ,o.charge_freq_cd -- 收费频率代码
    ,o.next_charge_dt -- 下一收费日期
    ,o.charge_dt -- 收费日
    ,o.charge_cust_acct_num -- 收费客户账号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dep_agt_id = n.dep_agt_id
            and o.phone = n.phone
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dep_agt_id = d.dep_agt_id
            and o.phone = d.phone
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_st_msg_sign_agt_h;
alter table ${iml_schema}.agt_st_msg_sign_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_st_msg_sign_agt_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_st_msg_sign_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_st_msg_sign_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_st_msg_sign_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_st_msg_sign_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

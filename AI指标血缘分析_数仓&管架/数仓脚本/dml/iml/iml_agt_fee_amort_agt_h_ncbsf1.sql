/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_fee_amort_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_fee_amort_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_amort_agt_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,cust_id -- 客户编号
    ,cont_id -- 合同编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账代码
    ,tran_code -- 交易码
    ,fee_type_cd -- 费用类型代码
    ,amort_status_cd -- 摊销状态代码
    ,amort_name -- 摊销名称
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tot_cnt -- 摊销总次数
    ,amorted_cnt -- 已摊销次数
    ,surp_amort_cnt -- 剩余摊销次数
    ,last_amort_dt -- 上一摊销日期
    ,next_amort_dt -- 下一摊销日期
    ,amort_curr_cd -- 摊销币种代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_mon -- 摊销月
    ,amort_day -- 摊销日
    ,amort_tot_amt -- 摊销总金额
    ,amorted_amt -- 已摊销金额
    ,surp_amort_amt -- 剩余摊销金额
    ,bank_tran_seq_num -- 银行交易序号
    ,batch_dtl_seq_num -- 批次明细序号
    ,bus_id -- 业务编号
    ,coll_flg_cd -- 收取标志代码
    ,recvbl_fee_seq_num -- 应收费用序号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_revd_flg -- 交易已冲正标志
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_org_id -- 冲正机构编号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_dt -- 冲正日期
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fee_amort_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_amort_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_fee_amort_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_fee_amortize_agr
insert into ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,cust_id -- 客户编号
    ,cont_id -- 合同编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账代码
    ,tran_code -- 交易码
    ,fee_type_cd -- 费用类型代码
    ,amort_status_cd -- 摊销状态代码
    ,amort_name -- 摊销名称
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tot_cnt -- 摊销总次数
    ,amorted_cnt -- 已摊销次数
    ,surp_amort_cnt -- 剩余摊销次数
    ,last_amort_dt -- 上一摊销日期
    ,next_amort_dt -- 下一摊销日期
    ,amort_curr_cd -- 摊销币种代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_mon -- 摊销月
    ,amort_day -- 摊销日
    ,amort_tot_amt -- 摊销总金额
    ,amorted_amt -- 已摊销金额
    ,surp_amort_amt -- 剩余摊销金额
    ,bank_tran_seq_num -- 银行交易序号
    ,batch_dtl_seq_num -- 批次明细序号
    ,bus_id -- 业务编号
    ,coll_flg_cd -- 收取标志代码
    ,recvbl_fee_seq_num -- 应收费用序号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_revd_flg -- 交易已冲正标志
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_org_id -- 冲正机构编号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_dt -- 冲正日期
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.AGREEMENT_ID -- 源协议编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CONTRACT_NO -- 合同编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.REFERENCE -- 交易参考号
    ,P1.CHANNEL_SEQ_NO -- 全局流水号
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,P1.REACCOUNT_CD -- 对账代码
    ,P1.TRAN_TYPE -- 交易码
    ,P1.FEE_TYPE -- 费用类型代码
    ,P1.AMORTIZE_STATUS -- 摊销状态代码
    ,P1.AMORTIZE_NAME -- 摊销名称
    ,P1.AMORTIZE_TIME_TYPE -- 摊销时间类型代码
    ,P1.AMORTIZE_TOTAL_CNT -- 摊销总次数
    ,P1.AMORTIZED_CNT -- 已摊销次数
    ,P1.REMAIN_AMORTIZE_CNT -- 剩余摊销次数
    ,P1.LAST_AMORTIZE_DATE -- 上一摊销日期
    ,P1.NEXT_AMORTIZE_DATE -- 下一摊销日期
    ,P1.AMORTIZE_CCY -- 摊销币种代码
    ,P1.AMORTIZE_PERIOD_TYPE -- 摊销期限类型代码
    ,P1.AMORTIZE_MONTH -- 摊销月
    ,P1.AMORTIZE_DAY -- 摊销日
    ,P1.AMORTIZE_TOTAL_AMT -- 摊销总金额
    ,P1.AMORTIZED_AMT -- 已摊销金额
    ,P1.REMAIN_AMORTIZE_AMT -- 剩余摊销金额
    ,P1.BANK_SEQ_NO -- 银行交易序号
    ,P1.BATCH_SEQ_NO -- 批次明细序号
    ,P1.BUSI_NO -- 业务编号
    ,P1.CHARGE_MODE -- 收取标志代码
    ,P1.OSD_SEQ_NO -- 应收费用序号
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,P1.SOURCE_TYPE -- 渠道编号
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.END_DATE -- 失效日期
    ,DECODE(TRIM(P1.REVERSAL_FLAG),'','-','Y','1','N','0',P1.REVERSAL_FLAG) -- 交易已冲正标志
    ,P1.REVERSAL_AUTH_USER_ID -- 冲正授权柜员编号
    ,P1.REVERSAL_BRANCH -- 冲正机构编号
    ,P1.REVERSAL_USER_ID -- 冲正柜员编号
    ,P1.REVERSAL_DATE -- 冲正日期
    ,P1.USER_ID -- 柜员编号
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.TRAN_DATE -- 交易日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_fee_amortize_agr' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_fee_amortize_agr p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,src_agt_id
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
        into ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,cust_id -- 客户编号
    ,cont_id -- 合同编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账代码
    ,tran_code -- 交易码
    ,fee_type_cd -- 费用类型代码
    ,amort_status_cd -- 摊销状态代码
    ,amort_name -- 摊销名称
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tot_cnt -- 摊销总次数
    ,amorted_cnt -- 已摊销次数
    ,surp_amort_cnt -- 剩余摊销次数
    ,last_amort_dt -- 上一摊销日期
    ,next_amort_dt -- 下一摊销日期
    ,amort_curr_cd -- 摊销币种代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_mon -- 摊销月
    ,amort_day -- 摊销日
    ,amort_tot_amt -- 摊销总金额
    ,amorted_amt -- 已摊销金额
    ,surp_amort_amt -- 剩余摊销金额
    ,bank_tran_seq_num -- 银行交易序号
    ,batch_dtl_seq_num -- 批次明细序号
    ,bus_id -- 业务编号
    ,coll_flg_cd -- 收取标志代码
    ,recvbl_fee_seq_num -- 应收费用序号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_revd_flg -- 交易已冲正标志
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_org_id -- 冲正机构编号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_dt -- 冲正日期
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,cust_id -- 客户编号
    ,cont_id -- 合同编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账代码
    ,tran_code -- 交易码
    ,fee_type_cd -- 费用类型代码
    ,amort_status_cd -- 摊销状态代码
    ,amort_name -- 摊销名称
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tot_cnt -- 摊销总次数
    ,amorted_cnt -- 已摊销次数
    ,surp_amort_cnt -- 剩余摊销次数
    ,last_amort_dt -- 上一摊销日期
    ,next_amort_dt -- 下一摊销日期
    ,amort_curr_cd -- 摊销币种代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_mon -- 摊销月
    ,amort_day -- 摊销日
    ,amort_tot_amt -- 摊销总金额
    ,amorted_amt -- 已摊销金额
    ,surp_amort_amt -- 剩余摊销金额
    ,bank_tran_seq_num -- 银行交易序号
    ,batch_dtl_seq_num -- 批次明细序号
    ,bus_id -- 业务编号
    ,coll_flg_cd -- 收取标志代码
    ,recvbl_fee_seq_num -- 应收费用序号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_revd_flg -- 交易已冲正标志
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_org_id -- 冲正机构编号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_dt -- 冲正日期
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
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
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.ova_flow_num, o.ova_flow_num) as ova_flow_num -- 全局流水号
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.check_entry_cd, o.check_entry_cd) as check_entry_cd -- 对账代码
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.fee_type_cd, o.fee_type_cd) as fee_type_cd -- 费用类型代码
    ,nvl(n.amort_status_cd, o.amort_status_cd) as amort_status_cd -- 摊销状态代码
    ,nvl(n.amort_name, o.amort_name) as amort_name -- 摊销名称
    ,nvl(n.amort_tm_type_cd, o.amort_tm_type_cd) as amort_tm_type_cd -- 摊销时间类型代码
    ,nvl(n.amort_tot_cnt, o.amort_tot_cnt) as amort_tot_cnt -- 摊销总次数
    ,nvl(n.amorted_cnt, o.amorted_cnt) as amorted_cnt -- 已摊销次数
    ,nvl(n.surp_amort_cnt, o.surp_amort_cnt) as surp_amort_cnt -- 剩余摊销次数
    ,nvl(n.last_amort_dt, o.last_amort_dt) as last_amort_dt -- 上一摊销日期
    ,nvl(n.next_amort_dt, o.next_amort_dt) as next_amort_dt -- 下一摊销日期
    ,nvl(n.amort_curr_cd, o.amort_curr_cd) as amort_curr_cd -- 摊销币种代码
    ,nvl(n.amort_tenor_type_cd, o.amort_tenor_type_cd) as amort_tenor_type_cd -- 摊销期限类型代码
    ,nvl(n.amort_mon, o.amort_mon) as amort_mon -- 摊销月
    ,nvl(n.amort_day, o.amort_day) as amort_day -- 摊销日
    ,nvl(n.amort_tot_amt, o.amort_tot_amt) as amort_tot_amt -- 摊销总金额
    ,nvl(n.amorted_amt, o.amorted_amt) as amorted_amt -- 已摊销金额
    ,nvl(n.surp_amort_amt, o.surp_amort_amt) as surp_amort_amt -- 剩余摊销金额
    ,nvl(n.bank_tran_seq_num, o.bank_tran_seq_num) as bank_tran_seq_num -- 银行交易序号
    ,nvl(n.batch_dtl_seq_num, o.batch_dtl_seq_num) as batch_dtl_seq_num -- 批次明细序号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.coll_flg_cd, o.coll_flg_cd) as coll_flg_cd -- 收取标志代码
    ,nvl(n.recvbl_fee_seq_num, o.recvbl_fee_seq_num) as recvbl_fee_seq_num -- 应收费用序号
    ,nvl(n.src_module_type_cd, o.src_module_type_cd) as src_module_type_cd -- 源模块类型代码
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.tran_revd_flg, o.tran_revd_flg) as tran_revd_flg -- 交易已冲正标志
    ,nvl(n.revs_auth_teller_id, o.revs_auth_teller_id) as revs_auth_teller_id -- 冲正授权柜员编号
    ,nvl(n.revs_org_id, o.revs_org_id) as revs_org_id -- 冲正机构编号
    ,nvl(n.revs_teller_id, o.revs_teller_id) as revs_teller_id -- 冲正柜员编号
    ,nvl(n.revs_dt, o.revs_dt) as revs_dt -- 冲正日期
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.src_agt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_agt_id = n.src_agt_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.src_agt_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.src_agt_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.cont_id <> n.cont_id
        or o.acct_id <> n.acct_id
        or o.tran_ref_no <> n.tran_ref_no
        or o.ova_flow_num <> n.ova_flow_num
        or o.bus_flow_num <> n.bus_flow_num
        or o.check_entry_cd <> n.check_entry_cd
        or o.tran_code <> n.tran_code
        or o.fee_type_cd <> n.fee_type_cd
        or o.amort_status_cd <> n.amort_status_cd
        or o.amort_name <> n.amort_name
        or o.amort_tm_type_cd <> n.amort_tm_type_cd
        or o.amort_tot_cnt <> n.amort_tot_cnt
        or o.amorted_cnt <> n.amorted_cnt
        or o.surp_amort_cnt <> n.surp_amort_cnt
        or o.last_amort_dt <> n.last_amort_dt
        or o.next_amort_dt <> n.next_amort_dt
        or o.amort_curr_cd <> n.amort_curr_cd
        or o.amort_tenor_type_cd <> n.amort_tenor_type_cd
        or o.amort_mon <> n.amort_mon
        or o.amort_day <> n.amort_day
        or o.amort_tot_amt <> n.amort_tot_amt
        or o.amorted_amt <> n.amorted_amt
        or o.surp_amort_amt <> n.surp_amort_amt
        or o.bank_tran_seq_num <> n.bank_tran_seq_num
        or o.batch_dtl_seq_num <> n.batch_dtl_seq_num
        or o.bus_id <> n.bus_id
        or o.coll_flg_cd <> n.coll_flg_cd
        or o.recvbl_fee_seq_num <> n.recvbl_fee_seq_num
        or o.src_module_type_cd <> n.src_module_type_cd
        or o.chn_id <> n.chn_id
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.tran_revd_flg <> n.tran_revd_flg
        or o.revs_auth_teller_id <> n.revs_auth_teller_id
        or o.revs_org_id <> n.revs_org_id
        or o.revs_teller_id <> n.revs_teller_id
        or o.revs_dt <> n.revs_dt
        or o.teller_id <> n.teller_id
        or o.auth_teller_id <> n.auth_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,cust_id -- 客户编号
    ,cont_id -- 合同编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账代码
    ,tran_code -- 交易码
    ,fee_type_cd -- 费用类型代码
    ,amort_status_cd -- 摊销状态代码
    ,amort_name -- 摊销名称
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tot_cnt -- 摊销总次数
    ,amorted_cnt -- 已摊销次数
    ,surp_amort_cnt -- 剩余摊销次数
    ,last_amort_dt -- 上一摊销日期
    ,next_amort_dt -- 下一摊销日期
    ,amort_curr_cd -- 摊销币种代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_mon -- 摊销月
    ,amort_day -- 摊销日
    ,amort_tot_amt -- 摊销总金额
    ,amorted_amt -- 已摊销金额
    ,surp_amort_amt -- 剩余摊销金额
    ,bank_tran_seq_num -- 银行交易序号
    ,batch_dtl_seq_num -- 批次明细序号
    ,bus_id -- 业务编号
    ,coll_flg_cd -- 收取标志代码
    ,recvbl_fee_seq_num -- 应收费用序号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_revd_flg -- 交易已冲正标志
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_org_id -- 冲正机构编号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_dt -- 冲正日期
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,cust_id -- 客户编号
    ,cont_id -- 合同编号
    ,acct_id -- 账户编号
    ,tran_ref_no -- 交易参考号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,check_entry_cd -- 对账代码
    ,tran_code -- 交易码
    ,fee_type_cd -- 费用类型代码
    ,amort_status_cd -- 摊销状态代码
    ,amort_name -- 摊销名称
    ,amort_tm_type_cd -- 摊销时间类型代码
    ,amort_tot_cnt -- 摊销总次数
    ,amorted_cnt -- 已摊销次数
    ,surp_amort_cnt -- 剩余摊销次数
    ,last_amort_dt -- 上一摊销日期
    ,next_amort_dt -- 下一摊销日期
    ,amort_curr_cd -- 摊销币种代码
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,amort_mon -- 摊销月
    ,amort_day -- 摊销日
    ,amort_tot_amt -- 摊销总金额
    ,amorted_amt -- 已摊销金额
    ,surp_amort_amt -- 剩余摊销金额
    ,bank_tran_seq_num -- 银行交易序号
    ,batch_dtl_seq_num -- 批次明细序号
    ,bus_id -- 业务编号
    ,coll_flg_cd -- 收取标志代码
    ,recvbl_fee_seq_num -- 应收费用序号
    ,src_module_type_cd -- 源模块类型代码
    ,chn_id -- 渠道编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,tran_revd_flg -- 交易已冲正标志
    ,revs_auth_teller_id -- 冲正授权柜员编号
    ,revs_org_id -- 冲正机构编号
    ,revs_teller_id -- 冲正柜员编号
    ,revs_dt -- 冲正日期
    ,teller_id -- 柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
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
    ,o.src_agt_id -- 源协议编号
    ,o.cust_id -- 客户编号
    ,o.cont_id -- 合同编号
    ,o.acct_id -- 账户编号
    ,o.tran_ref_no -- 交易参考号
    ,o.ova_flow_num -- 全局流水号
    ,o.bus_flow_num -- 业务流水号
    ,o.check_entry_cd -- 对账代码
    ,o.tran_code -- 交易码
    ,o.fee_type_cd -- 费用类型代码
    ,o.amort_status_cd -- 摊销状态代码
    ,o.amort_name -- 摊销名称
    ,o.amort_tm_type_cd -- 摊销时间类型代码
    ,o.amort_tot_cnt -- 摊销总次数
    ,o.amorted_cnt -- 已摊销次数
    ,o.surp_amort_cnt -- 剩余摊销次数
    ,o.last_amort_dt -- 上一摊销日期
    ,o.next_amort_dt -- 下一摊销日期
    ,o.amort_curr_cd -- 摊销币种代码
    ,o.amort_tenor_type_cd -- 摊销期限类型代码
    ,o.amort_mon -- 摊销月
    ,o.amort_day -- 摊销日
    ,o.amort_tot_amt -- 摊销总金额
    ,o.amorted_amt -- 已摊销金额
    ,o.surp_amort_amt -- 剩余摊销金额
    ,o.bank_tran_seq_num -- 银行交易序号
    ,o.batch_dtl_seq_num -- 批次明细序号
    ,o.bus_id -- 业务编号
    ,o.coll_flg_cd -- 收取标志代码
    ,o.recvbl_fee_seq_num -- 应收费用序号
    ,o.src_module_type_cd -- 源模块类型代码
    ,o.chn_id -- 渠道编号
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.tran_revd_flg -- 交易已冲正标志
    ,o.revs_auth_teller_id -- 冲正授权柜员编号
    ,o.revs_org_id -- 冲正机构编号
    ,o.revs_teller_id -- 冲正柜员编号
    ,o.revs_dt -- 冲正日期
    ,o.teller_id -- 柜员编号
    ,o.auth_teller_id -- 授权柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
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
from ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.src_agt_id = n.src_agt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.src_agt_id = d.src_agt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_fee_amort_agt_h;
--alter table ${iml_schema}.agt_fee_amort_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_fee_amort_agt_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_fee_amort_agt_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_fee_amort_agt_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_fee_amort_agt_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_fee_amort_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_fee_amort_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_fee_amort_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_fee_amort_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

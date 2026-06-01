/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_conl_bk_payoff_batch_mpcsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_conl_bk_payoff_batch_mpcsi1_tm purge;
alter table ${iml_schema}.evt_conl_bk_payoff_batch add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_conl_bk_payoff_batch modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_batch_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,batch_id -- 批次编号
    ,batch_dt -- 批次日期
    ,payoff_kind_cd -- 代发种类代码
    ,re_payoff_sys_cd -- 实际代发系统代码
    ,chn_dt -- 渠道日期
    ,chn_seq_num -- 渠道序号
    ,batch_doc_id -- 批量文件编号
    ,cust_id -- 客户编号
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,curr_cd -- 币种代码
    ,tot_qtty -- 总数量
    ,sucs_tot_qtty -- 成功总数量
    ,fail_tot_qtty -- 失败总数量
    ,tot_amt -- 总金额
    ,sucs_tot_amt -- 成功总金额
    ,fail_tot_amt -- 失败总金额
    ,tran_tm -- 交易时间
    ,need_acct_tran_flg -- 需要账户过渡标志
    ,tran_acct_id -- 过渡账户编号
    ,tran_acct_name -- 过渡账户名称
    ,postsc -- 附言
    ,flow_status_cd -- 流程状态代码
    ,err_info_desc -- 错误信息描述
    ,cntpty_acct_bank_out_flg -- 对手账户行外标志
    ,corp_acct_bank_out_flg -- 对公账户行外标志
    ,tran_inside_acct_acct_num -- 过渡内部户账号
    ,tran_inside_acct_name -- 过渡内部户名称
    ,core_prpery_flow_num -- 核心外围流水号
    ,core_flow_num -- 核心流水号
    ,core_entry_dt -- 核心记账日期
    ,sign_org_id -- 签约机构编号
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_conl_bk_payoff_batch
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a01tbatmanage-
insert into ${iml_schema}.evt_conl_bk_payoff_batch_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,chn_id -- 渠道编号
    ,batch_id -- 批次编号
    ,batch_dt -- 批次日期
    ,payoff_kind_cd -- 代发种类代码
    ,re_payoff_sys_cd -- 实际代发系统代码
    ,chn_dt -- 渠道日期
    ,chn_seq_num -- 渠道序号
    ,batch_doc_id -- 批量文件编号
    ,cust_id -- 客户编号
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,curr_cd -- 币种代码
    ,tot_qtty -- 总数量
    ,sucs_tot_qtty -- 成功总数量
    ,fail_tot_qtty -- 失败总数量
    ,tot_amt -- 总金额
    ,sucs_tot_amt -- 成功总金额
    ,fail_tot_amt -- 失败总金额
    ,tran_tm -- 交易时间
    ,need_acct_tran_flg -- 需要账户过渡标志
    ,tran_acct_id -- 过渡账户编号
    ,tran_acct_name -- 过渡账户名称
    ,postsc -- 附言
    ,flow_status_cd -- 流程状态代码
    ,err_info_desc -- 错误信息描述
    ,cntpty_acct_bank_out_flg -- 对手账户行外标志
    ,corp_acct_bank_out_flg -- 对公账户行外标志
    ,tran_inside_acct_acct_num -- 过渡内部户账号
    ,tran_inside_acct_name -- 过渡内部户名称
    ,core_prpery_flow_num -- 核心外围流水号
    ,core_flow_num -- 核心流水号
    ,core_entry_dt -- 核心记账日期
    ,sign_org_id -- 签约机构编号
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201019'||P1.CHNLID||P1.BATCHNO||P1.FNTDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CHNLID -- 渠道编号
    ,P1.BATCHNO -- 批次编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.FNTDT) -- 批次日期
    ,NVL(TRIM(P1.BATCHTYPE),'-') -- 代发种类代码
    ,NVL(TRIM(P1.REALCHN),'-') -- 实际代发系统代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.FNTDT) -- 渠道日期
    ,P1.FNTSEQNO -- 渠道序号
    ,P1.FILENAME -- 批量文件编号
    ,P1.CUSTNO -- 客户编号
    ,P1.PAYACCTNO -- 转出账户编号
    ,P1.PAYACCTNAME -- 转出账户名称
    ,CASE WHEN TRIM(P1.CCY)='01' THEN 'CNY' ELSE NVL(TRIM(P1.CCY),'-') END -- 币种代码
    ,TO_NUMBER(NVL(TRIM(P1.TOTALNUM),0)) -- 总数量
    ,TO_NUMBER(NVL(TRIM(P1.SUCCNUM),0)) -- 成功总数量
    ,TO_NUMBER(NVL(TRIM(P1.FAILNUM),0)) -- 失败总数量
    ,TO_NUMBER(NVL(TRIM(P1.TOTALAMT),0)) -- 总金额
    ,TO_NUMBER(NVL(TRIM(P1.SUCCAMT),0)) -- 成功总金额
    ,TO_NUMBER(NVL(TRIM(P1.FAILAMT),0)) -- 失败总金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRNDTTS) -- 交易时间
    ,NVL(TRIM(P1.TMPFLAG),'-') -- 需要账户过渡标志
    ,P1.TMPACCTNO -- 过渡账户编号
    ,P1.TMPACCTNAME -- 过渡账户名称
    ,P1.MEMO -- 附言
    ,NVL(TRIM(P1.STAT),'-') -- 流程状态代码
    ,P1.RESERVE -- 错误信息描述
    ,NVL(TRIM(P1.CROSSFLAG),'-') -- 对手账户行外标志
    ,NVL(TRIM(P1.OTHERFLAG),'-') -- 对公账户行外标志
    ,P1.INNERACNO -- 过渡内部户账号
    ,P1.INNERACNA -- 过渡内部户名称
    ,P1.DATAID -- 核心外围流水号
    ,P1.HOSTSEQNO -- 核心流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.HOSTSEQDT) -- 核心记账日期
    ,P1.BRCNO -- 签约机构编号
    ,P1.TLRNO -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a01tbatmanage' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a01tbatmanage p1
where  1 = 1 
    AND P1.FNTDT= '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_conl_bk_payoff_batch truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_conl_bk_payoff_batch exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_conl_bk_payoff_batch_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_conl_bk_payoff_batch to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_conl_bk_payoff_batch_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_conl_bk_payoff_batch', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_mercht_clear_info_mpcsi1
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
drop table ${iml_schema}.evt_mercht_clear_info_mpcsi1_tm purge;
alter table ${iml_schema}.evt_mercht_clear_info add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_mercht_clear_info modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_clear_info_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_tran_dt -- 中台交易日期
    ,unionpay_tran_dt -- 银联交易日期
    ,core_tran_dt -- 核心交易日期
    ,clear_day_term -- 清算日期
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,core_flow_num -- 核心流水号
    ,mercht_id -- 商户编号
    ,acct_id -- 账户编号
    ,org_id -- 机构编号
    ,unionpay_org_id -- 银联机构编号
    ,actl_enter_acct_id -- 实际入账编号
    ,mercht_name -- 商户名称
    ,sign_org_name -- 签约机构名称
    ,expd_mercht_name -- 拓展商名称
    ,tran_amt -- 交易金额
    ,mercht_serv_fee -- 商户服务费
    ,comm_fee -- 手续费
    ,consm_amt -- 消费金额
    ,rtn_goods_amt -- 退货金额
    ,consm_revs_amt -- 消费沖正金额
    ,rtn_goods_revs_amt -- 退货沖正金额
    ,debit_adj_amt -- 借记调整金额
    ,crdt_adj_amt -- 贷记调整金额
    ,tran_status_cd -- 交易状态代码
    ,enter_acct_status_cd -- 入账状态代码
    ,tran_tot -- 交易总笔数
    ,hxb_acct_flg -- 我行账户标志
    ,postsc -- 附言
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_mercht_clear_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a51ubmerchantacct-
insert into ${iml_schema}.evt_mercht_clear_info_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_tran_dt -- 中台交易日期
    ,unionpay_tran_dt -- 银联交易日期
    ,core_tran_dt -- 核心交易日期
    ,clear_day_term -- 清算日期
    ,midgrod_tran_flow_num -- 中台交易流水号
    ,core_flow_num -- 核心流水号
    ,mercht_id -- 商户编号
    ,acct_id -- 账户编号
    ,org_id -- 机构编号
    ,unionpay_org_id -- 银联机构编号
    ,actl_enter_acct_id -- 实际入账编号
    ,mercht_name -- 商户名称
    ,sign_org_name -- 签约机构名称
    ,expd_mercht_name -- 拓展商名称
    ,tran_amt -- 交易金额
    ,mercht_serv_fee -- 商户服务费
    ,comm_fee -- 手续费
    ,consm_amt -- 消费金额
    ,rtn_goods_amt -- 退货金额
    ,consm_revs_amt -- 消费沖正金额
    ,rtn_goods_revs_amt -- 退货沖正金额
    ,debit_adj_amt -- 借记调整金额
    ,crdt_adj_amt -- 贷记调整金额
    ,enter_acct_status_cd -- 交易状态代码
    ,tran_status_cd -- 入账状态代码
    ,tran_tot -- 交易总笔数
    ,hxb_acct_flg -- 我行账户标志
    ,postsc -- 附言
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201010'||P1.TRANDT||P1.TRANSDATE||P1.MERCHANTCODE -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TRANDT) -- 中台交易日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.TRANSDATE) -- 银联交易日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.HOSTDATE) -- 核心交易日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.DATEOFSTLM) -- 清算日期
    ,P1.TRANSNBR -- 中台交易流水号
    ,P1.HOSTNBR -- 核心流水号
    ,P1.MERCHANTCODE -- 商户编号
    ,P1.ACCTNO -- 账户编号
    ,P1.BRCHNO -- 机构编号
    ,P1.BRCHBR -- 银联机构编号
    ,P1.REMARK1 -- 实际入账编号
    ,P1.MERCHANTNAME -- 商户名称
    ,P1.BANKNAME -- 签约机构名称
    ,P1.REMARK4 -- 拓展商名称
    ,P1.TRANSAMT -- 交易金额
    ,P1.MCHTSEVIFEE -- 商户服务费
    ,P1.SUMOFFEE -- 手续费
    ,P1.PCAAMT -- 消费金额
    ,P1.PPTAMT -- 退货金额
    ,P1.RVSLPCAAMT -- 消费沖正金额
    ,P1.RVSLPPTAMT -- 退货沖正金额
    ,P1.DADJAMT -- 借记调整金额
    ,P1.CADJAMT -- 贷记调整金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 交易状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRANST END -- 入账状态代码
    ,P1.TRANSNUM -- 交易总笔数
    ,DECODE(P1.ACCTIOFLG,'1','1','2','0') -- 我行账户标志
    ,P1.REMARK3 -- 附言
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a51ubmerchantacct' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a51ubmerchantacct p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A51UBMERCHANTACCT'
        AND R2.SRC_FIELD_EN_NAME= 'STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_MERCHT_CLEAR_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ENTER_ACCT_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRANST = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A51UBMERCHANTACCT'
        AND R1.SRC_FIELD_EN_NAME= 'TRANST'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_MERCHT_CLEAR_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
where  1 = 1 
    AND P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_mercht_clear_info truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_mercht_clear_info exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_mercht_clear_info_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_mercht_clear_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_mercht_clear_info_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_mercht_clear_info', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bigamt_cash_tran_dtl_nibsi1
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
drop table ${iml_schema}.evt_bigamt_cash_tran_dtl_nibsi1_tm purge;
alter table ${iml_schema}.evt_bigamt_cash_tran_dtl add partition p_nibsi1 values ('nibsi1')(
        subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_bigamt_cash_tran_dtl modify partition p_nibsi1
    add subpartition p_nibsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bigamt_cash_tran_dtl_nibsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,acct_name -- 账户名称
    ,tran_card_id -- 交易卡编号
    ,dep_draw_type_cd -- 存取款类型代码
    ,dep_draw_type_comnt -- 存取款类型说明
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_dt -- 交易日期
    ,modif_dt -- 修改日期
    ,org_id -- 机构编号
    ,tran_teller_id -- 交易柜员编号
    ,modif_teller_id -- 修改柜员编号
    ,cust_type_cd -- 客户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,bigamt_cash_precon_id -- 大额取现预约编号
    ,indus_categy_cd -- 行业门类代码
    ,indus_gen_cd -- 行业大类代码
    ,indus_middle_class_cd -- 行业中类代码
    ,indus_sclass_cd -- 行业小类代码
    ,bus_type_cd -- 业务类型代码
    ,redt_amt_tot -- 转存金额汇总
    ,acct_type_cd -- 账户类型代码
    ,agent_type_cd -- 代理类型代码
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_name -- 代理人姓名
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bigamt_cash_tran_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- nibs_ab_largecash_regi-
insert into ${iml_schema}.evt_bigamt_cash_tran_dtl_nibsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,flow_num -- 流水号
    ,tran_flow_num -- 交易流水号
    ,ova_flow_num -- 全局流水号
    ,core_flow_num -- 核心流水号
    ,acct_name -- 账户名称
    ,tran_card_id -- 交易卡编号
    ,dep_draw_type_cd -- 存取款类型代码
    ,dep_draw_type_comnt -- 存取款类型说明
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,tran_dt -- 交易日期
    ,modif_dt -- 修改日期
    ,org_id -- 机构编号
    ,tran_teller_id -- 交易柜员编号
    ,modif_teller_id -- 修改柜员编号
    ,cust_type_cd -- 客户类型代码
    ,tran_chn_cd -- 交易渠道代码
    ,bigamt_cash_precon_id -- 大额取现预约编号
    ,indus_categy_cd -- 行业门类代码
    ,indus_gen_cd -- 行业大类代码
    ,indus_middle_class_cd -- 行业中类代码
    ,indus_sclass_cd -- 行业小类代码
    ,bus_type_cd -- 业务类型代码
    ,redt_amt_tot -- 转存金额汇总
    ,acct_type_cd -- 账户类型代码
    ,agent_type_cd -- 代理类型代码
    ,agent_cert_type_cd -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_name -- 代理人姓名
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102060'||P1.TID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TID -- 流水号
    ,P1.TRANSQ -- 交易流水号
    ,P1.GLOBALSEQNO -- 全局流水号
    ,P1.CORESEQNO -- 核心流水号
    ,P1.ACCTNA -- 账户名称
    ,P1.ACCTNO -- 交易卡编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.BUSINESSTYPE||P1.CUSTTP||P1.WITHDRAWALUSE END -- 存取款类型代码
    ,P1.DESCRIPTION -- 存取款类型说明
    ,P1.CRCYCD -- 币种代码
    ,P1.TRANAM -- 交易金额
    ,P1.TRANDATE -- 交易日期
    ,P1.UPDATEDATE -- 修改日期
    ,P1.BRCHNO -- 机构编号
    ,P1.USERID -- 交易柜员编号
    ,P1.UPUSERID -- 修改柜员编号
    ,nvl(trim(P1.CUSTTP),'-') -- 客户类型代码
    ,P1.SERVTP -- 交易渠道代码
    ,P1.RESERNUMBER -- 大额取现预约编号
    ,NVL(SUBSTR(TRIM(P1.INDUCATEGORY),1,1),'-') -- 行业门类代码
    ,NVL(SUBSTR(TRIM(P1.INDUBIG),1,3),'-') -- 行业大类代码
    ,NVL(SUBSTR(TRIM(P1.INDUMEDIUM),1,5),'-') -- 行业中类代码
    ,NVL(TRIM(P1.INDUSMALL),'-') -- 行业小类代码
    ,P1.BUSINESSTYPE -- 业务类型代码
    ,P1.SAVETOAMSUM -- 转存金额汇总
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.SPECTP END -- 账户类型代码
    ,NVL(TRIM(P1.AGNTTG),'-') -- 代理类型代码
    ,nvl(trim(P1.AGIDTP),'0000') -- 代理人证件类型代码
    ,P1.AGIDNO -- 代理人证件号码
    ,P1.AGCUNA -- 代理人姓名
    ,P1.TRANTIME -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_ab_largecash_regi' -- 源表名称
    ,'nibsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ab_largecash_regi p1
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.BUSINESSTYPE||P1.CUSTTP||P1.WITHDRAWALUSE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'NIBS'
        AND R5.SRC_TAB_EN_NAME= 'NIBS_AB_LARGECASH_REGI'
        AND R5.SRC_FIELD_EN_NAME= 'WITHDRAWALUSE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_CASH_TRAN_DTL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'DEP_DRAW_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CRCYCD= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NIBS'
        AND R1.SRC_TAB_EN_NAME= 'NIBS_AB_LARGECASH_REGI'
        AND R1.SRC_FIELD_EN_NAME= 'CRCYCD'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_CASH_TRAN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CUSTTP= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'NIBS'
        AND R2.SRC_TAB_EN_NAME= 'NIBS_AB_LARGECASH_REGI'
        AND R2.SRC_FIELD_EN_NAME= 'CUSTTP'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_CASH_TRAN_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.SPECTP= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'NIBS'
        AND R3.SRC_TAB_EN_NAME= 'NIBS_AB_LARGECASH_REGI'
        AND R3.SRC_FIELD_EN_NAME= 'SPECTP'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_BIGAMT_CASH_TRAN_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ACCT_TYPE_CD'
where  1 = 1 
    AND P1.TRANDATE=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_bigamt_cash_tran_dtl truncate subpartition p_nibsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_bigamt_cash_tran_dtl exchange subpartition p_nibsi1_${batch_date} with table ${iml_schema}.evt_bigamt_cash_tran_dtl_nibsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bigamt_cash_tran_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_bigamt_cash_tran_dtl_nibsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bigamt_cash_tran_dtl', partname => 'p_nibsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
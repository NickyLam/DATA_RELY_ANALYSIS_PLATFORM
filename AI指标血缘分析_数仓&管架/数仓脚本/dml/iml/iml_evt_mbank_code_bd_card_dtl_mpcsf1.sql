/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_mbank_code_bd_card_dtl_mpcsf1
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
drop table ${iml_schema}.evt_mbank_code_bd_card_dtl_mpcsf1_tm purge;
alter table ${iml_schema}.evt_mbank_code_bd_card_dtl add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_mbank_code_bd_card_dtl modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mbank_code_bd_card_dtl_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bind_flow_num -- 绑定流水号
    ,tran_chn_cd -- 交易渠道代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,vtual_card_no -- 虚拟卡号
    ,enty_c_acct_id -- 实体卡账户编号
    ,enty_c_acct_open_no -- 实体卡账户开户行行号
    ,enty_c_acct_open_name -- 实体卡账户开户行行名
    ,enty_c_acct_type_cd -- 实体卡账户类型代码
    ,bd_card_tm -- 绑卡时间
    ,bd_card_status_cd -- 绑卡状态代码
    ,obank_flg -- 他行标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,card_iss_org_id -- 发卡机构编号
    ,deflt_pay_card_flg -- 默认支付卡标志
    ,data_kind_cd -- 数据种类代码
    ,update_tm -- 更新时间
    ,latest_update_flow_num -- 最新更新流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_mbank_code_bd_card_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a50ubtrsamtlimit-1
insert into ${iml_schema}.evt_mbank_code_bd_card_dtl_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bind_flow_num -- 绑定流水号
    ,tran_chn_cd -- 交易渠道代码
    ,sign_type_cd -- 签约类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,vtual_card_no -- 虚拟卡号
    ,enty_c_acct_id -- 实体卡账户编号
    ,enty_c_acct_open_no -- 实体卡账户开户行行号
    ,enty_c_acct_open_name -- 实体卡账户开户行行名
    ,enty_c_acct_type_cd -- 实体卡账户类型代码
    ,bd_card_tm -- 绑卡时间
    ,bd_card_status_cd -- 绑卡状态代码
    ,obank_flg -- 他行标志
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,card_iss_org_id -- 发卡机构编号
    ,deflt_pay_card_flg -- 默认支付卡标志
    ,data_kind_cd -- 数据种类代码
    ,update_tm -- 更新时间
    ,latest_update_flow_num -- 最新更新流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104043'||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 绑定流水号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CHNLID END -- 交易渠道代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PRODUCT END -- 签约类型代码
    ,P1.CUSTNO -- 客户编号
    ,P1.CUSTNAME -- 客户名称
    ,P1.TOKENID -- 虚拟卡号
    ,P1.ACCTNO -- 实体卡账户编号
    ,P1.ACCTOPBK -- 实体卡账户开户行行号
    ,P1.ACCTOPBKNAME -- 实体卡账户开户行行名
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.ACCTTYPE END -- 实体卡账户类型代码
    ,${iml_schema}.TIMEFORMAT_MAX(P1.ADDTIME) -- 绑卡时间
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 绑卡状态代码
    ,P1.GHBFLAG -- 他行标志
    ,P1.TLRNO -- 交易柜员编号
    ,P1.BRCHNO -- 交易机构编号
    ,P1.ISSINSCODE -- 发卡机构编号
    ,P1.ISPAYCARD -- 默认支付卡标志
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.MSGGRADE END -- 数据种类代码
    ,${iml_schema}.TIMEFORMAT_MAX(P1.UPDATETIME) -- 更新时间
    ,P1.UPDATESEQ -- 最新更新流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a50ubtrsamtlimit' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a50ubtrsamtlimit p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CHNLID = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A50UBTRSAMTLIMIT'
        AND R1.SRC_FIELD_EN_NAME= 'CHNLID'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_MBANK_CODE_BD_CARD_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRODUCT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A50UBTRSAMTLIMIT'
        AND R2.SRC_FIELD_EN_NAME= 'PRODUCT'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_MBANK_CODE_BD_CARD_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'SIGN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.ACCTTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A50UBTRSAMTLIMIT'
        AND R3.SRC_FIELD_EN_NAME= 'ACCTTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_MBANK_CODE_BD_CARD_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'ENTY_C_ACCT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.STATUS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A50UBTRSAMTLIMIT'
        AND R4.SRC_FIELD_EN_NAME= 'STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_MBANK_CODE_BD_CARD_DTL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'BD_CARD_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.MSGGRADE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A50UBTRSAMTLIMIT'
        AND R5.SRC_FIELD_EN_NAME= 'MSGGRADE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_MBANK_CODE_BD_CARD_DTL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'DATA_KIND_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_mbank_code_bd_card_dtl truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_mbank_code_bd_card_dtl exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_mbank_code_bd_card_dtl_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_mbank_code_bd_card_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_mbank_code_bd_card_dtl_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_mbank_code_bd_card_dtl', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
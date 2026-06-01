/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_syn_sign_flow_mpcsf1
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
drop table ${iml_schema}.evt_syn_sign_flow_mpcsf1_tm purge;
alter table ${iml_schema}.evt_syn_sign_flow add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_syn_sign_flow modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_syn_sign_flow_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,chn_cd -- 渠道代码
    ,chn_flow_num -- 渠道流水号
    ,trdpty_flow_num -- 第三方流水号
    ,core_flow_num -- 核心流水号
    ,tran_type_cd -- 交易类型代码
    ,cont_id -- 合约编号
    ,agt_cd -- 协议代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,sign_dt -- 签约日期
    ,sign_tm -- 签约时间
    ,org_id -- 机构编号
    ,sign_teller_id -- 签约柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,trdpty_sys_tran_code -- 第三方系统交易码
    ,trdpty_tran_name -- 第三方交易名称
    ,tran_rest_cd -- 交易结果代码
    ,vouch_print_flg -- 凭证打印标志
    ,print_opera_id -- 打印作业编号
    ,remark -- 备注
    ,tran_comnt -- 交易说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_syn_sign_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a02tcontracttranlist-
insert into ${iml_schema}.evt_syn_sign_flow_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sign_flow_num -- 签约流水号
    ,chn_cd -- 渠道代码
    ,chn_flow_num -- 渠道流水号
    ,trdpty_flow_num -- 第三方流水号
    ,core_flow_num -- 核心流水号
    ,tran_type_cd -- 交易类型代码
    ,cont_id -- 合约编号
    ,agt_cd -- 协议代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,sign_dt -- 签约日期
    ,sign_tm -- 签约时间
    ,org_id -- 机构编号
    ,sign_teller_id -- 签约柜员编号
    ,auth_teller_id -- 授权柜员编号
    ,trdpty_sys_tran_code -- 第三方系统交易码
    ,trdpty_tran_name -- 第三方交易名称
    ,tran_rest_cd -- 交易结果代码
    ,vouch_print_flg -- 凭证打印标志
    ,print_opera_id -- 打印作业编号
    ,remark -- 备注
    ,tran_comnt -- 交易说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104037'||P1.FNTSEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.FNTSEQNO -- 签约流水号
    ,nvl(trim(P1.CHNLID),'-') -- 渠道代码
    ,P1.CHNLSEQNO -- 渠道流水号
    ,P1.THIRDSEQNO -- 第三方流水号
    ,P1.HOSTSEQNO -- 核心流水号
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.TRNTYPE END -- 交易类型代码
    ,P1.MAINCONTRACTNO -- 合约编号
    ,P1.CONTRACTNO -- 协议代码
    ,P1.CUSTNO -- 客户编号
    ,P1.ACCTNO -- 账户编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRNDT) -- 签约日期
    ,${iml_schema}.DATEFORMAT_MIN(p1.TRNDT||P1.TRNTS) -- 签约时间
    ,P1.TRNBRCNO -- 机构编号
    ,P1.TLRNO -- 签约柜员编号
    ,P1.AUTHTLRNO -- 授权柜员编号
    ,P1.DSTTRNCD -- 第三方系统交易码
    ,P1.TRNNAME -- 第三方交易名称
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.TRNRESULT END -- 交易结果代码
    ,nvl(trim(P1.PRTTIMES),'-') -- 凭证打印标志
    ,P1.PRTWORKNO -- 打印作业编号
    ,P1.MEMO -- 备注
    ,P1.OPDATA -- 交易说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a02tcontracttranlist' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a02tcontracttranlist p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CHNLID = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A02TCONTRACTTRANLIST'
        AND R1.SRC_FIELD_EN_NAME= 'CHNLID'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_SYN_SIGN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CHN_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.TRNTYPE = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'MPCS'
        AND R8.SRC_TAB_EN_NAME= 'MPCS_A02TCONTRACTTRANLIST'
        AND R8.SRC_FIELD_EN_NAME= 'TRNTYPE'
        AND R8.TARGET_TAB_EN_NAME= 'EVT_SYN_SIGN_FLOW'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.TRNRESULT = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'MPCS'
        AND R7.SRC_TAB_EN_NAME= 'MPCS_A02TCONTRACTTRANLIST'
        AND R7.SRC_FIELD_EN_NAME= 'TRNRESULT'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_SYN_SIGN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'TRAN_REST_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_syn_sign_flow truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_syn_sign_flow exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_syn_sign_flow_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_syn_sign_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_syn_sign_flow_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_syn_sign_flow', partname => 'p_mpcsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);
/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_pub_tran_flow_ncbsi1
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
drop table ${iml_schema}.ref_pub_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.ref_pub_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_pub_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_pub_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    seq_num -- 序号
    ,lp_id -- 法人编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,tran_ref_no -- 交易参考号
    ,sys_flow_num -- 系统流水号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,bank_org_id -- 银行机构编号
    ,src_chn_id -- 源渠道编号
    ,src_module_cd -- 源模块代码
    ,chn_dt -- 渠道日期
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,accti_status_cd -- 核算状态代码
    ,evt_cate -- 事件类别
    ,amt_type_cd -- 金额类型代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt -- 交易金额
    ,tran_code -- 交易码
    ,bus_flow_num -- 业务流水号
    ,bus_tran_dt -- 业务交易日期
    ,bus_proc_status_cd -- 业务处理状态代码
    ,tran_memo_descb -- 交易摘要描述
    ,revs_flow_num -- 冲正流水号
    ,revs_flg -- 冲正标志
    ,sign_cntpty_curr_cd -- 签约对手币种代码
    ,sys_id -- 系统编号
    ,init_tran_ref_no -- 原交易参考号
    ,create_entry_flg -- 生成分录标志
    ,entry_spdst_start_dt -- 分录试算开始日期
    ,subj_id -- 科目编号
    ,gl -- 总账
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_pub_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_tb_tran_hist-1
insert into ${iml_schema}.ref_pub_tran_flow_ncbsi1_tm(
    seq_num -- 序号
    ,lp_id -- 法人编号
    ,chn_tran_flow_num -- 渠道交易流水号
    ,tran_ref_no -- 交易参考号
    ,sys_flow_num -- 系统流水号
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,bank_org_id -- 银行机构编号
    ,src_chn_id -- 源渠道编号
    ,src_module_cd -- 源模块代码
    ,chn_dt -- 渠道日期
    ,prod_id -- 产品编号
    ,acct_curr_cd -- 账户币种代码
    ,cust_id -- 客户编号
    ,cust_type_cd -- 客户类型代码
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,accti_status_cd -- 核算状态代码
    ,evt_cate -- 事件类别
    ,amt_type_cd -- 金额类型代码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt -- 交易金额
    ,tran_code -- 交易码
    ,bus_flow_num -- 业务流水号
    ,bus_tran_dt -- 业务交易日期
    ,bus_proc_status_cd -- 业务处理状态代码
    ,tran_memo_descb -- 交易摘要描述
    ,revs_flow_num -- 冲正流水号
    ,revs_flg -- 冲正标志
    ,sign_cntpty_curr_cd -- 签约对手币种代码
    ,sys_id -- 系统编号
    ,init_tran_ref_no -- 原交易参考号
    ,create_entry_flg -- 生成分录标志
    ,entry_spdst_start_dt -- 分录试算开始日期
    ,subj_id -- 科目编号
    ,gl -- 总账
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SEQ_NO -- 序号
    ,'9999' -- 法人编号
    ,P1.CHANNEL_SEQ_NO -- 渠道交易流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.SUB_SEQ_NO -- 系统流水号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.BRANCH -- 银行机构编号
    ,nvl(trim(P1.SOURCE_TYPE),'0000') -- 源渠道编号
    ,nvl(trim(P1.SOURCE_MODULE),'-') -- 源模块代码
    ,P1.CHANNEL_DATE -- 渠道日期
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 账户币种代码
    ,P1.CLIENT_NO -- 客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,P1.EVENT_TYPE -- 事件类别
    ,nvl(trim(P1.AMT_TYPE),'-') -- 金额类型代码
    ,nvl(trim(P1.CCY),'-') -- 交易币种代码
    ,P1.TRAN_AMT -- 交易金额
    ,P1.TRAN_TYPE -- 交易码
    ,P1.BUS_SEQ_NO -- 业务流水号
    ,P1.TRAN_DATE -- 业务交易日期
    ,nvl(trim(P1.TRAN_STATUS),'-') -- 业务处理状态代码
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.REVERSAL_SEQ_NO -- 冲正流水号
    ,decode(trim(P1.RESERVE_FLAG),'','-','Y','1','N','0',P1.RESERVE_FLAG) -- 冲正标志
    ,nvl(trim(P1.OTH_CCY),'-') -- 签约对手币种代码
    ,P1.SYSTEM_ID -- 系统编号
    ,P1.PRE_REFERENCE -- 原交易参考号
    ,decode(trim(P1.POST_FLAG),'','-','Y','1','N','0',P1.POST_FLAG) -- 生成分录标志
    ,P1.EFFECT_DATE -- 分录试算开始日期
    ,P1.GL_CODE -- 科目编号
    ,P1.GL_SEQ_NO -- 总账
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_tb_tran_hist' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_tb_tran_hist p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_TB_TRAN_HIST'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_PUB_TRAN_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where  1 = 1 
     and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.ref_pub_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.ref_pub_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.ref_pub_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_pub_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_pub_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_pub_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
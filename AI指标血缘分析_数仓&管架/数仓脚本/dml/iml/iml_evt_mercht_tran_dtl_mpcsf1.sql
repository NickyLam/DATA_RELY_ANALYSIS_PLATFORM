/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_mercht_tran_dtl_mpcsf1
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
drop table ${iml_schema}.evt_mercht_tran_dtl_mpcsf1_tm purge;
alter table ${iml_schema}.evt_mercht_tran_dtl add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_mercht_tran_dtl modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_mercht_tran_dtl_mpcsf1_tm
compress ${option_switch} for query high
as
select
    card_no -- 卡号
    ,lp_id -- 法人编号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,retriv_ref_id -- 检索参考编号
    ,tran_type_descb -- 交易类型描述
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,mercht_no -- 商户号
    ,mercht_name -- 商户名称
    ,unionpay_mercht_cate_cd -- 银联商户类别代码
    ,mercht_comm_fee -- 商户手续费
    ,int_paybl_amt -- 应付金额
    ,recvbl_amt -- 应收金额
    ,debit_crdt_flg -- 借贷标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_mercht_tran_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a51ubmerdetaillistcoma-
insert into ${iml_schema}.evt_mercht_tran_dtl_mpcsf1_tm(
    card_no -- 卡号
    ,lp_id -- 法人编号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,retriv_ref_id -- 检索参考编号
    ,tran_type_descb -- 交易类型描述
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,mercht_no -- 商户号
    ,mercht_name -- 商户名称
    ,unionpay_mercht_cate_cd -- 银联商户类别代码
    ,mercht_comm_fee -- 商户手续费
    ,int_paybl_amt -- 应付金额
    ,recvbl_amt -- 应收金额
    ,debit_crdt_flg -- 借贷标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.PRIACCT -- 卡号
    ,'9999' -- 法人编号
    ,TO_TIMESTAMP(TRIM(substr(TRIM(P1.TRANSDATE),1,4) || (substr(TRIM(P1.TRANSTIME),1,10))),'YYYY-MM-DD HH24:MI:SS') -- 交易时间
    ,TO_DATE(P1.TRANSDATE,'YYYYMMDD') -- 交易日期
    ,P1.RETRIVAREFNUM -- 检索参考编号
    ,P1.REMARK2 -- 交易类型描述
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CURRCYCODE END -- 币种代码
    ,P1.TRANSAMT -- 交易金额
    ,P1.ACCPTRID -- 商户号
    ,P1.REMARK3 -- 商户名称
    ,P1.MCHNTTYPE -- 银联商户类别代码
    ,P1.MERFEE -- 商户手续费
    ,P1.TRANAMT -- 应付金额
    ,P1.RECVAMT -- 应收金额
    ,P1.TRANFLAG -- 借贷标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a51ubmerdetaillistcoma' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a51ubmerdetaillistcoma p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CURRCYCODE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A51UBMERDETAILLISTCOMA'
        AND R1.SRC_FIELD_EN_NAME= 'CURRCYCODE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_MERCHT_TRAN_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CURR_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_mercht_tran_dtl truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_mercht_tran_dtl exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_mercht_tran_dtl_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_mercht_tran_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_mercht_tran_dtl_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_mercht_tran_dtl', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
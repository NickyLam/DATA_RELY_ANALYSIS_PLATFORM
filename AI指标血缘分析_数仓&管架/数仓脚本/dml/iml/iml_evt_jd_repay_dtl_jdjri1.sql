/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_jd_repay_dtl_jdjri1
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
drop table ${iml_schema}.evt_jd_repay_dtl_jdjri1_tm purge;
alter table ${iml_schema}.evt_jd_repay_dtl add partition p_jdjri1 values ('jdjri1')(
        subpartition p_jdjri1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_jd_repay_dtl modify partition p_jdjri1
    add subpartition p_jdjri1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_jd_repay_dtl_jdjri1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_dt -- 还款日期
    ,repay_flow_num -- 还款流水号
    ,repay_way_cd -- 还款方式代码
    ,acm_rpbl_pric_amt -- 累计应还本金
    ,paid_pric_amt -- 实还本金
    ,acm_rpbl_int_bal -- 累计应还利息
    ,paid_int_amt -- 实还利息
    ,acm_rpbl_pnlt_bal -- 累计应还罚息
    ,paid_pnlt_amt -- 实还罚息
    ,repay_perds -- 还款期数
    ,surp_repay_perds -- 剩余还款期数
    ,repay_type_cd -- 还款类型代码
    ,serv_fee -- 服务费
    ,coll_fee -- 催收费
    ,prod_id -- 产品编号
    ,recvbl -- 资方应收固收
    ,recvbl_nomal_prft -- 资方应收分润正常收益
    ,recvbl_ovdue_prft -- 资方应收分润逾期收益
    ,acm_rpbl_penalty -- 累计应还违约金
    ,paid_penalty -- 实还违约金
    ,ovdue_days -- 贷款逾期天数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_jd_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_jdjr_repay_detail-
insert into ${iml_schema}.evt_jd_repay_dtl_jdjri1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,inst_odd_no -- 分期单号
    ,repay_dt -- 还款日期
    ,repay_flow_num -- 还款流水号
    ,repay_way_cd -- 还款方式代码
    ,acm_rpbl_pric_amt -- 累计应还本金
    ,paid_pric_amt -- 实还本金
    ,acm_rpbl_int_bal -- 累计应还利息
    ,paid_int_amt -- 实还利息
    ,acm_rpbl_pnlt_bal -- 累计应还罚息
    ,paid_pnlt_amt -- 实还罚息
    ,repay_perds -- 还款期数
    ,surp_repay_perds -- 剩余还款期数
    ,repay_type_cd -- 还款类型代码
    ,serv_fee -- 服务费
    ,coll_fee -- 催收费
    ,prod_id -- 产品编号
    ,recvbl -- 资方应收固收
    ,recvbl_nomal_prft -- 资方应收分润正常收益
    ,recvbl_ovdue_prft -- 资方应收分润逾期收益
    ,acm_rpbl_penalty -- 累计应还违约金
    ,paid_penalty -- 实还违约金
    ,ovdue_days -- 贷款逾期天数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102034'||P1.TERMNO||P1.REPAYMODEL||P1.BUSSDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.CONTNO -- 合同编号
    ,P1.PRDNO -- 京东产品代码
    ,P1.LIMITNO -- 客户额度编号
    ,P1.LOANNO -- 借据编号
    ,P1.TERMNO -- 分期单号
    ,${iml_schema}.dateformat_max2(trim(P1.REPAYDT)) -- 还款日期
    ,P1.REPAYSERNO -- 还款流水号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REPAYTYPE END -- 还款方式代码
    ,P1.CURRTERMAMT -- 累计应还本金
    ,P1.REALREPAYAMT -- 实还本金
    ,P1.CURRTERMINT -- 累计应还利息
    ,P1.REALREPAYINT -- 实还利息
    ,P1.CURRTERMPNLT -- 累计应还罚息
    ,P1.REALREPAYPNLT -- 实还罚息
    ,P1.REPAYTERMS -- 还款期数
    ,P1.UNPAYTERMS -- 剩余还款期数
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.REPAYMODEL END  -- 还款类型代码
    ,P1.SERVICEFEE -- 服务费
    ,P1.COLLECTFEE -- 催收费
    ,P1.PRDCODE -- 产品编号
    ,P1.MANGRECFIXED -- 资方应收固收
    ,P1.MANGNORINCOME -- 资方应收分润正常收益
    ,P1.MANGOVDINCOME -- 资方应收分润逾期收益
    ,P1.ACCREPAYVOLFEE -- 累计应还违约金
    ,P1.REALREAPYVOLFEE -- 实还违约金
    ,P1.OVDDAYS -- 贷款逾期天数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_jdjr_repay_detail' -- 源表名称
    ,'jdjri1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_jdjr_repay_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAYTYPE  = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_JDJR_REPAY_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'REPAYTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_JD_REPAY_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.REPAYMODEL = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_JDJR_REPAY_DETAIL'
        AND R2.SRC_FIELD_EN_NAME= 'REPAYMODEL'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_JD_REPAY_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'REPAY_TYPE_CD'       
where  1 = 1 
    and p1.BUSSDATE = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_jd_repay_dtl truncate subpartition p_jdjri1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_jd_repay_dtl exchange subpartition p_jdjri1_${batch_date} with table ${iml_schema}.evt_jd_repay_dtl_jdjri1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_jd_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_jd_repay_dtl_jdjri1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_jd_repay_dtl', partname => 'p_jdjri1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
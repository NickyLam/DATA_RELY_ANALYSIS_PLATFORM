/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wyd_dubil_attach_info_icmsf1
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
drop table ${iml_schema}.agt_wyd_dubil_attach_info_icmsf1_tm purge;
alter table ${iml_schema}.agt_wyd_dubil_attach_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wyd_dubil_attach_info modify partition p_icmsf1
    add subpartition p_icmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_dubil_attach_info_icmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,level11_cls_cd -- 十一级分类代码
    ,loan_cate_cd -- 贷款类别代码
    ,loan_type_cd -- 贷款类型代码
    ,loan_num -- 总期数
    ,curr_perds -- 当前期数
    ,indus_subclass_cd -- 行业细类代码
    ,repay_freq_cd -- 还款频率代码
    ,guar_way_cd -- 担保方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,next_int_rat_reval_day -- 下一利率重定价日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_accr_flg -- 计息标志
    ,int_recvbl -- 应收利息
    ,grace_period -- 宽限期
    ,ovdue_days -- 贷款逾期天数
    ,pric_ovdue_dt -- 本金逾期日期
    ,ovdue_pric -- 逾期本金
    ,int_ovdue_dt -- 利息逾期日期
    ,ovdue_int -- 逾期利息
    ,ovdue_tot_amt -- 逾期总金额
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,revo_dt -- 撤销日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,proj_id -- 项目编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wyd_dubil_attach_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wyd_loan_detail-1
insert into ${iml_schema}.agt_wyd_dubil_attach_info_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cont_id -- 合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,level5_cls_cd -- 五级分类代码
    ,level11_cls_cd -- 十一级分类代码
    ,indus_subclass_cd -- 贷款类别代码
    ,loan_cate_cd -- 贷款类型代码
    ,loan_type_cd -- 总期数
    ,loan_num -- 当前期数
    ,curr_perds -- 行业细类代码
    ,repay_freq_cd -- 还款频率代码
    ,guar_way_cd -- 担保方式代码
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,next_int_rat_reval_day -- 下一利率重定价日期
    ,int_rat_type_cd -- 利率类型代码
    ,int_accr_flg -- 计息标志
    ,int_recvbl -- 应收利息
    ,grace_period -- 宽限期
    ,ovdue_days -- 贷款逾期天数
    ,pric_ovdue_dt -- 本金逾期日期
    ,ovdue_pric -- 逾期本金
    ,int_ovdue_dt -- 利息逾期日期
    ,ovdue_int -- 逾期利息
    ,ovdue_tot_amt -- 逾期总金额
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,revo_dt -- 撤销日期
    ,payoff_dt -- 结清日期
    ,wrt_off_dt -- 核销日期
    ,proj_id -- 项目编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_belong_org_id -- 登记所属机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300066'||P1.LENDINGREF -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LENDINGREF -- 借据编号
    ,P1.CONTRACTNO -- 合同编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.COREENTERPRISENAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim（P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,nvl(trim（P1.CLASSIFYRESULTELEVEN),'20') -- 十一级分类代码
    ,nvl(trim（P1.LOANPURPOSE),'-') -- 贷款类别代码
    ,nvl(trim（P1.LOANTYPE),'-') -- 贷款类型代码
    ,nvl(trim（P1.LOANTYPESTAGE),'-') -- 总期数
    ,P1.PINITTERM -- 当前期数
    ,P1.PCURRTERM -- 行业细类代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.PAYMENTFEQ END -- 还款频率代码
    ,nvl(trim（P1.GUARTYPE),'-') -- 担保方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'|| P1.PAYWAY END -- 放款支付方式代码
    ,${iml_schema}.dateformat_max2(P1.REPRICINGDATE) -- 下一利率重定价日期
    ,nvl(trim(P1.RATETYPE),'-') -- 利率类型代码
    ,decode(P1.INTRTYP,' ','-','Y','1','N','0',P1.INTRTYP) -- 计息标志
    ,P1.INRECEIVEBALANCE -- 应收利息
    ,P1.GRACEPERIOD -- 宽限期
    ,P1.OVERDUEDAYS -- 贷款逾期天数
    ,${iml_schema}.dateformat_max2(P1.PRINODDATE) -- 本金逾期日期
    ,P1.PRINODAMT -- 逾期本金
    ,${iml_schema}.dateformat_max2(P1.INTODDATE) -- 利息逾期日期
    ,P1.INTODAMT -- 逾期利息
    ,P1.POVERDUEAMT -- 逾期总金额
    ,decode(P1.RECOMFLG,' ','-','Y','1','N','0',P1.RECOMFLG) -- 重组贷款标志
    ,${iml_schema}.dateformat_max2(P1.RECOMDATE) -- 重组日期
    ,${iml_schema}.dateformat_max2(P1.PCANCELDATE) -- 撤销日期
    ,${iml_schema}.dateformat_max2(P1.PAIDOUTDATE) -- 结清日期
    ,${iml_schema}.dateformat_max2(P1.WTODATE) -- 核销日期
    ,P1.COREPROJECTID -- 项目编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记所属机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wyd_loan_detail' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wyd_loan_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAYMENTFEQ = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_WYD_LOAN_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'PAYMENTFEQ'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_WYD_DUBIL_ATTACH_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_FREQ_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PAYWAY = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_WYD_LOAN_DETAIL'
        AND R2.SRC_FIELD_EN_NAME= 'PAYWAY'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_WYD_DUBIL_ATTACH_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DISTR_MODE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.RATETYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_WYD_LOAN_DETAIL'
        AND R3.SRC_FIELD_EN_NAME= 'RATETYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_WYD_DUBIL_ATTACH_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_TYPE_CD'
where  1 = 1 
    and p1.etl_dt=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_wyd_dubil_attach_info truncate subpartition p_icmsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_wyd_dubil_attach_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wyd_dubil_attach_info_icmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wyd_dubil_attach_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wyd_dubil_attach_info_icmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wyd_dubil_attach_info', partname => 'p_icmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
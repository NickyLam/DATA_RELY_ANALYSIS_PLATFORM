/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_appl_hqd_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_appl_hqd_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_hqd_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,lmt_appl_flow_num -- 授信申请流水号
    ,prod_id -- 产品编号
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,advise_flg -- 通知展业标志
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,cust_mgr_opinion -- 客户经理意见
    ,th_year_degree_workr_num -- 本年度从业人数
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,update_cust_mgr_id -- 更新客户经理编号
    ,new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,up_date -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_hqd_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_hqd_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_appl_hqd_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_hqd_iqp_loan_app-1
insert into ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,lmt_appl_flow_num -- 授信申请流水号
    ,prod_id -- 产品编号
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,advise_flg -- 通知展业标志
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,cust_mgr_opinion -- 客户经理意见
    ,th_year_degree_workr_num -- 本年度从业人数
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,update_cust_mgr_id -- 更新客户经理编号
    ,new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,up_date -- 更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206004'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.APPLYNO -- 信贷申请流水号
    ,P1.BANO -- 授信申请流水号
    ,P1.PRDCODE -- 产品编号
    ,P1.CHANNELNO -- 产品简称
    ,P1.APPLYAMT -- 申请金额
    ,P1.TERMMONTH -- 贷款期限
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.ISCYCLE),'-') -- 额度循环标志
    ,P1.INPUTDATE -- 审批申请日期
    ,P1.ZSAPPLYENDDATE -- 审批结束日期
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.FINALAPPLYAMOUNT -- 审批额度
    ,nvl(trim(P1.INFORMFLAG),'-') -- 通知展业标志
    ,P1.WARNINGINFO -- 预警信息
    ,P1.FAILREASON -- 拒绝原因描述
    ,P1.MANAGERQUEST -- 客户经理意见
    ,P1.ANNUALEMPSNUM -- 本年度从业人数
    ,P1.ACTUALCONTROLLEREMPYEARS -- 实控人从业年限
    ,P1.FLOWANNUALSALESREVENUE -- 流水推算年销售收入
    ,P1.NOCREDITEACHDEBTACCUBALANCE -- 征信未体现的负债余额
    ,P1.NOCREDITMONTHACCUREPAYDEBT -- 征信未体现的月还款额
    ,P1.ENTMONTHREPAYBALANCE -- 企业月还款额
    ,nvl(trim(P1.ISPLEDGEDRECEIVEACCOUNT),'-') -- 企业应收账款质押标志
    ,P1.PLEDGERECEIVEAMT -- 应收账款质押贷款金额
    ,P1.KNOWAGEPLEDGERECEIVEAMT -- 知识产权质押贷款金额
    ,nvl(trim(P1.ISSTOCKPLEDGED),'-') -- 股权质押标志
    ,P1.STOCKPLEDGEDAMT -- 股权质押贷款金额
    ,P1.INPUTUSERID -- 客户经理编号
    ,P1.INPUTORGID -- 客户经理所属机构编号
    ,P1.BELONGORGID -- 客户经理所属分行机构编号
    ,P1.UPDATEUSERID -- 更新客户经理编号
    ,P1.UPDATEORGID -- 更新客户经理所属机构编号
    ,P1.UPDATEDATE -- 更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_hqd_iqp_loan_app' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_hqd_iqp_loan_app p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
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
        into ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,lmt_appl_flow_num -- 授信申请流水号
    ,prod_id -- 产品编号
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,advise_flg -- 通知展业标志
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,cust_mgr_opinion -- 客户经理意见
    ,th_year_degree_workr_num -- 本年度从业人数
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,update_cust_mgr_id -- 更新客户经理编号
    ,new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,lmt_appl_flow_num -- 授信申请流水号
    ,prod_id -- 产品编号
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,advise_flg -- 通知展业标志
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,cust_mgr_opinion -- 客户经理意见
    ,th_year_degree_workr_num -- 本年度从业人数
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,update_cust_mgr_id -- 更新客户经理编号
    ,new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.crdt_appl_flow_num, o.crdt_appl_flow_num) as crdt_appl_flow_num -- 信贷申请流水号
    ,nvl(n.lmt_appl_flow_num, o.lmt_appl_flow_num) as lmt_appl_flow_num -- 授信申请流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_abbr, o.prod_abbr) as prod_abbr -- 产品简称
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.lmt_circl_flg, o.lmt_circl_flg) as lmt_circl_flg -- 额度循环标志
    ,nvl(n.apv_appl_dt, o.apv_appl_dt) as apv_appl_dt -- 审批申请日期
    ,nvl(n.apv_end_dt, o.apv_end_dt) as apv_end_dt -- 审批结束日期
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.apv_lmt, o.apv_lmt) as apv_lmt -- 审批额度
    ,nvl(n.advise_flg, o.advise_flg) as advise_flg -- 通知展业标志
    ,nvl(n.warn_info, o.warn_info) as warn_info -- 预警信息
    ,nvl(n.refuse_rs_descb, o.refuse_rs_descb) as refuse_rs_descb -- 拒绝原因描述
    ,nvl(n.cust_mgr_opinion, o.cust_mgr_opinion) as cust_mgr_opinion -- 客户经理意见
    ,nvl(n.th_year_degree_workr_num, o.th_year_degree_workr_num) as th_year_degree_workr_num -- 本年度从业人数
    ,nvl(n.actl_ctrler_work_years, o.actl_ctrler_work_years) as actl_ctrler_work_years -- 实控人从业年限
    ,nvl(n.flow_calcu_year_sell_inco, o.flow_calcu_year_sell_inco) as flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,nvl(n.crdtc_not_embody_liab_bal, o.crdtc_not_embody_liab_bal) as crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,nvl(n.crdtc_not_mon_second_marke, o.crdtc_not_mon_second_marke) as crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,nvl(n.corp_mon_second_marke, o.corp_mon_second_marke) as corp_mon_second_marke -- 企业月还款额
    ,nvl(n.corp_acct_recvbl_inpwn_flg, o.corp_acct_recvbl_inpwn_flg) as corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,nvl(n.acct_recvbl_inpwn_loan_amt, o.acct_recvbl_inpwn_loan_amt) as acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,nvl(n.intel_prop_inpwn_loan_amt, o.intel_prop_inpwn_loan_amt) as intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,nvl(n.share_right_inpwn_flg, o.share_right_inpwn_flg) as share_right_inpwn_flg -- 股权质押标志
    ,nvl(n.share_right_inpwn_loan_amt, o.share_right_inpwn_loan_amt) as share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.cust_mgr_belong_org_id, o.cust_mgr_belong_org_id) as cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,nvl(n.cust_mgr_belong_brch_org_id, o.cust_mgr_belong_brch_org_id) as cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,nvl(n.update_cust_mgr_id, o.update_cust_mgr_id) as update_cust_mgr_id -- 更新客户经理编号
    ,nvl(n.new_cust_mgr_belong_org_id, o.new_cust_mgr_belong_org_id) as new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,nvl(n.up_date, o.up_date) as up_date -- 更新日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.appl_flow_num <> n.appl_flow_num
        or o.crdt_appl_flow_num <> n.crdt_appl_flow_num
        or o.lmt_appl_flow_num <> n.lmt_appl_flow_num
        or o.prod_id <> n.prod_id
        or o.prod_abbr <> n.prod_abbr
        or o.appl_amt <> n.appl_amt
        or o.loan_tenor <> n.loan_tenor
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.lmt_circl_flg <> n.lmt_circl_flg
        or o.apv_appl_dt <> n.apv_appl_dt
        or o.apv_end_dt <> n.apv_end_dt
        or o.apv_status_cd <> n.apv_status_cd
        or o.apv_lmt <> n.apv_lmt
        or o.advise_flg <> n.advise_flg
        or o.warn_info <> n.warn_info
        or o.refuse_rs_descb <> n.refuse_rs_descb
        or o.cust_mgr_opinion <> n.cust_mgr_opinion
        or o.th_year_degree_workr_num <> n.th_year_degree_workr_num
        or o.actl_ctrler_work_years <> n.actl_ctrler_work_years
        or o.flow_calcu_year_sell_inco <> n.flow_calcu_year_sell_inco
        or o.crdtc_not_embody_liab_bal <> n.crdtc_not_embody_liab_bal
        or o.crdtc_not_mon_second_marke <> n.crdtc_not_mon_second_marke
        or o.corp_mon_second_marke <> n.corp_mon_second_marke
        or o.corp_acct_recvbl_inpwn_flg <> n.corp_acct_recvbl_inpwn_flg
        or o.acct_recvbl_inpwn_loan_amt <> n.acct_recvbl_inpwn_loan_amt
        or o.intel_prop_inpwn_loan_amt <> n.intel_prop_inpwn_loan_amt
        or o.share_right_inpwn_flg <> n.share_right_inpwn_flg
        or o.share_right_inpwn_loan_amt <> n.share_right_inpwn_loan_amt
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.cust_mgr_belong_org_id <> n.cust_mgr_belong_org_id
        or o.cust_mgr_belong_brch_org_id <> n.cust_mgr_belong_brch_org_id
        or o.update_cust_mgr_id <> n.update_cust_mgr_id
        or o.new_cust_mgr_belong_org_id <> n.new_cust_mgr_belong_org_id
        or o.up_date <> n.up_date
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,lmt_appl_flow_num -- 授信申请流水号
    ,prod_id -- 产品编号
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,advise_flg -- 通知展业标志
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,cust_mgr_opinion -- 客户经理意见
    ,th_year_degree_workr_num -- 本年度从业人数
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,update_cust_mgr_id -- 更新客户经理编号
    ,new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,crdt_appl_flow_num -- 信贷申请流水号
    ,lmt_appl_flow_num -- 授信申请流水号
    ,prod_id -- 产品编号
    ,prod_abbr -- 产品简称
    ,appl_amt -- 申请金额
    ,loan_tenor -- 贷款期限
    ,main_guar_way_cd -- 主担保方式代码
    ,lmt_circl_flg -- 额度循环标志
    ,apv_appl_dt -- 审批申请日期
    ,apv_end_dt -- 审批结束日期
    ,apv_status_cd -- 审批状态代码
    ,apv_lmt -- 审批额度
    ,advise_flg -- 通知展业标志
    ,warn_info -- 预警信息
    ,refuse_rs_descb -- 拒绝原因描述
    ,cust_mgr_opinion -- 客户经理意见
    ,th_year_degree_workr_num -- 本年度从业人数
    ,actl_ctrler_work_years -- 实控人从业年限
    ,flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,corp_mon_second_marke -- 企业月还款额
    ,corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,share_right_inpwn_flg -- 股权质押标志
    ,share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,update_cust_mgr_id -- 更新客户经理编号
    ,new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.appl_flow_num -- 申请流水号
    ,o.crdt_appl_flow_num -- 信贷申请流水号
    ,o.lmt_appl_flow_num -- 授信申请流水号
    ,o.prod_id -- 产品编号
    ,o.prod_abbr -- 产品简称
    ,o.appl_amt -- 申请金额
    ,o.loan_tenor -- 贷款期限
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.lmt_circl_flg -- 额度循环标志
    ,o.apv_appl_dt -- 审批申请日期
    ,o.apv_end_dt -- 审批结束日期
    ,o.apv_status_cd -- 审批状态代码
    ,o.apv_lmt -- 审批额度
    ,o.advise_flg -- 通知展业标志
    ,o.warn_info -- 预警信息
    ,o.refuse_rs_descb -- 拒绝原因描述
    ,o.cust_mgr_opinion -- 客户经理意见
    ,o.th_year_degree_workr_num -- 本年度从业人数
    ,o.actl_ctrler_work_years -- 实控人从业年限
    ,o.flow_calcu_year_sell_inco -- 流水推算年销售收入
    ,o.crdtc_not_embody_liab_bal -- 征信未体现的负债余额
    ,o.crdtc_not_mon_second_marke -- 征信未体现的月还款额
    ,o.corp_mon_second_marke -- 企业月还款额
    ,o.corp_acct_recvbl_inpwn_flg -- 企业应收账款质押标志
    ,o.acct_recvbl_inpwn_loan_amt -- 应收账款质押贷款金额
    ,o.intel_prop_inpwn_loan_amt -- 知识产权质押贷款金额
    ,o.share_right_inpwn_flg -- 股权质押标志
    ,o.share_right_inpwn_loan_amt -- 股权质押贷款金额
    ,o.cust_mgr_id -- 客户经理编号
    ,o.cust_mgr_belong_org_id -- 客户经理所属机构编号
    ,o.cust_mgr_belong_brch_org_id -- 客户经理所属分行机构编号
    ,o.update_cust_mgr_id -- 更新客户经理编号
    ,o.new_cust_mgr_belong_org_id -- 更新客户经理所属机构编号
    ,o.up_date -- 更新日期
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
from ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_appl_hqd_attach_info_h;
--alter table ${iml_schema}.agt_loan_appl_hqd_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_appl_hqd_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_appl_hqd_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_loan_appl_hqd_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_appl_hqd_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_appl_hqd_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_appl_hqd_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_appl_hqd_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_appl_hqd_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

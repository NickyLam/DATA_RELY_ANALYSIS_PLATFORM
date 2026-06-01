/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ap_handle_info_h_icmsf1
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
alter table ${iml_schema}.agt_ap_handle_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ap_handle_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ap_handle_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ap_handle_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_ap_handle_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_ap_handle_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ap_handle_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,del_flg -- 删除标志
    ,apedx_id -- 附件编号
    ,prop_kind_id -- 方案种类编号
    ,main_disp_type_cd -- 主处置类型代码
    ,disp_type_cd -- 处置类型代码
    ,subrch_prvlg_flg -- 分支行权限标志
    ,reply_id -- 批复编号
    ,reply_content_descb -- 批复内容描述
    ,reply_input_dt -- 批复录入日期
    ,apv_status_cd -- 审批状态代码
    ,disp_amt -- 处置金额
    ,rpbl_pric_amt -- 应还本金金额
    ,rpbl_in_bs_int_amt -- 应还表内利息金额
    ,rpbl_off_bs_int_amt -- 应还表外利息金额
    ,derate_pric_amt -- 减免本金金额
    ,derate_tot_amt -- 减免总金额
    ,derate_in_bs_int_amt -- 减免表内利息金额
    ,derate_off_bs_int_amt -- 减免表外利息金额
    ,derate_bf_pric_bal -- 减免前本金余额
    ,derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,risk_asset_comb -- 风险资产组合
    ,prop_descb -- 方案描述
    ,move_remark -- 迁移标识
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ap_handle_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_ap_handle_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ap_handle_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_ap_handle_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ap_handle_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_ap_handle_program-1
insert into ${iml_schema}.agt_ap_handle_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,del_flg -- 删除标志
    ,apedx_id -- 附件编号
    ,prop_kind_id -- 方案种类编号
    ,main_disp_type_cd -- 主处置类型代码
    ,disp_type_cd -- 处置类型代码
    ,subrch_prvlg_flg -- 分支行权限标志
    ,reply_id -- 批复编号
    ,reply_content_descb -- 批复内容描述
    ,reply_input_dt -- 批复录入日期
    ,apv_status_cd -- 审批状态代码
    ,disp_amt -- 处置金额
    ,rpbl_pric_amt -- 应还本金金额
    ,rpbl_in_bs_int_amt -- 应还表内利息金额
    ,rpbl_off_bs_int_amt -- 应还表外利息金额
    ,derate_pric_amt -- 减免本金金额
    ,derate_tot_amt -- 减免总金额
    ,derate_in_bs_int_amt -- 减免表内利息金额
    ,derate_off_bs_int_amt -- 减免表外利息金额
    ,derate_bf_pric_bal -- 减免前本金余额
    ,derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,risk_asset_comb -- 风险资产组合
    ,prop_descb -- 方案描述
    ,move_remark -- 迁移标识
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300038'||P1.PROGRAMNO  -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PROGRAMNO -- 方案编号
    ,P1.PROGRAMNAME -- 方案名称
    ,nvl(trim(P1.DELETEFLAG),'-') -- 删除标志
    ,P1.FILENO -- 附件编号
    ,P1.PROGRAMKIND -- 方案种类编号
    ,nvl(trim(P1.MAINHANDLETYPE),'-') -- 主处置类型代码
    ,nvl(trim(P1.HANDLETYPE),'-') -- 处置类型代码
    ,nvl(trim(P1.OVERAPPROVEFLAG),'-') -- 分支行权限标志
    ,P1.APPROVENO -- 批复编号
    ,P1.APPROVECONTENT -- 批复内容描述
    ,${iml_schema}.dateformat_min(P1.APPROVEINPUTDATE) -- 批复录入日期
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 审批状态代码
    ,P1.HANDLEAMOUNT -- 处置金额
    ,P1.PAYBALANCE -- 应还本金金额
    ,P1.PAYONBALINTEREST -- 应还表内利息金额
    ,P1.PAYOUTBALINTEREST -- 应还表外利息金额
    ,P1.RELIEFBALANCE -- 减免本金金额
    ,P1.RELIEFSUM -- 减免总金额
    ,P1.RELIEFONBALINTEREST -- 减免表内利息金额
    ,P1.RELIEFOUTBALINTEREST -- 减免表外利息金额
    ,P1.PRERELIEFBALANCE -- 减免前本金余额
    ,P1.PREONDEBITINTEREST -- 减免前表内欠息金额
    ,P1.PREOUTDEBITINTEREST -- 减免前表外欠息金额
    ,nvl(trim(P1.CERTTYPE),'-') -- 借款人证件类型代码
    ,P1.CERTID -- 借款人证件号码
    ,P1.THRIDCUSTOMER -- 方案涉及第三客户描述
    ,P1.CUSTOMERNAME -- 方案涉及第三客户名称组合
    ,P1.CUSTOMERID -- 方案涉及第三客户编号组合
    ,P1.RISKASSETLIST -- 风险资产组合
    ,P1.SUMMARIZE -- 方案描述
    ,P1.MIGTFLAG -- 迁移标识
    ,P1.REMARK -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,${iml_schema}.dateformat_min(P1.INPUTDATE) -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,${iml_schema}.dateformat_max2(P1.UPDATEDATE) -- 更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_ap_handle_program' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ap_handle_program p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ap_handle_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_ap_handle_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,del_flg -- 删除标志
    ,apedx_id -- 附件编号
    ,prop_kind_id -- 方案种类编号
    ,main_disp_type_cd -- 主处置类型代码
    ,disp_type_cd -- 处置类型代码
    ,subrch_prvlg_flg -- 分支行权限标志
    ,reply_id -- 批复编号
    ,reply_content_descb -- 批复内容描述
    ,reply_input_dt -- 批复录入日期
    ,apv_status_cd -- 审批状态代码
    ,disp_amt -- 处置金额
    ,rpbl_pric_amt -- 应还本金金额
    ,rpbl_in_bs_int_amt -- 应还表内利息金额
    ,rpbl_off_bs_int_amt -- 应还表外利息金额
    ,derate_pric_amt -- 减免本金金额
    ,derate_tot_amt -- 减免总金额
    ,derate_in_bs_int_amt -- 减免表内利息金额
    ,derate_off_bs_int_amt -- 减免表外利息金额
    ,derate_bf_pric_bal -- 减免前本金余额
    ,derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,risk_asset_comb -- 风险资产组合
    ,prop_descb -- 方案描述
    ,move_remark -- 迁移标识
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ap_handle_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,del_flg -- 删除标志
    ,apedx_id -- 附件编号
    ,prop_kind_id -- 方案种类编号
    ,main_disp_type_cd -- 主处置类型代码
    ,disp_type_cd -- 处置类型代码
    ,subrch_prvlg_flg -- 分支行权限标志
    ,reply_id -- 批复编号
    ,reply_content_descb -- 批复内容描述
    ,reply_input_dt -- 批复录入日期
    ,apv_status_cd -- 审批状态代码
    ,disp_amt -- 处置金额
    ,rpbl_pric_amt -- 应还本金金额
    ,rpbl_in_bs_int_amt -- 应还表内利息金额
    ,rpbl_off_bs_int_amt -- 应还表外利息金额
    ,derate_pric_amt -- 减免本金金额
    ,derate_tot_amt -- 减免总金额
    ,derate_in_bs_int_amt -- 减免表内利息金额
    ,derate_off_bs_int_amt -- 减免表外利息金额
    ,derate_bf_pric_bal -- 减免前本金余额
    ,derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,risk_asset_comb -- 风险资产组合
    ,prop_descb -- 方案描述
    ,move_remark -- 迁移标识
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.prop_id, o.prop_id) as prop_id -- 方案编号
    ,nvl(n.prop_name, o.prop_name) as prop_name -- 方案名称
    ,nvl(n.del_flg, o.del_flg) as del_flg -- 删除标志
    ,nvl(n.apedx_id, o.apedx_id) as apedx_id -- 附件编号
    ,nvl(n.prop_kind_id, o.prop_kind_id) as prop_kind_id -- 方案种类编号
    ,nvl(n.main_disp_type_cd, o.main_disp_type_cd) as main_disp_type_cd -- 主处置类型代码
    ,nvl(n.disp_type_cd, o.disp_type_cd) as disp_type_cd -- 处置类型代码
    ,nvl(n.subrch_prvlg_flg, o.subrch_prvlg_flg) as subrch_prvlg_flg -- 分支行权限标志
    ,nvl(n.reply_id, o.reply_id) as reply_id -- 批复编号
    ,nvl(n.reply_content_descb, o.reply_content_descb) as reply_content_descb -- 批复内容描述
    ,nvl(n.reply_input_dt, o.reply_input_dt) as reply_input_dt -- 批复录入日期
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.disp_amt, o.disp_amt) as disp_amt -- 处置金额
    ,nvl(n.rpbl_pric_amt, o.rpbl_pric_amt) as rpbl_pric_amt -- 应还本金金额
    ,nvl(n.rpbl_in_bs_int_amt, o.rpbl_in_bs_int_amt) as rpbl_in_bs_int_amt -- 应还表内利息金额
    ,nvl(n.rpbl_off_bs_int_amt, o.rpbl_off_bs_int_amt) as rpbl_off_bs_int_amt -- 应还表外利息金额
    ,nvl(n.derate_pric_amt, o.derate_pric_amt) as derate_pric_amt -- 减免本金金额
    ,nvl(n.derate_tot_amt, o.derate_tot_amt) as derate_tot_amt -- 减免总金额
    ,nvl(n.derate_in_bs_int_amt, o.derate_in_bs_int_amt) as derate_in_bs_int_amt -- 减免表内利息金额
    ,nvl(n.derate_off_bs_int_amt, o.derate_off_bs_int_amt) as derate_off_bs_int_amt -- 减免表外利息金额
    ,nvl(n.derate_bf_pric_bal, o.derate_bf_pric_bal) as derate_bf_pric_bal -- 减免前本金余额
    ,nvl(n.derate_bf_in_bs_over_int_amt, o.derate_bf_in_bs_over_int_amt) as derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,nvl(n.derate_bf_off_bs_over_int_amt, o.derate_bf_off_bs_over_int_amt) as derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,nvl(n.brwer_cert_type_cd, o.brwer_cert_type_cd) as brwer_cert_type_cd -- 借款人证件类型代码
    ,nvl(n.brwer_cert_no, o.brwer_cert_no) as brwer_cert_no -- 借款人证件号码
    ,nvl(n.prop_invo_trd_cust_descb, o.prop_invo_trd_cust_descb) as prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,nvl(n.prop_invo_trd_cust_name_comb, o.prop_invo_trd_cust_name_comb) as prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,nvl(n.prop_invo_trd_cust_id_comb, o.prop_invo_trd_cust_id_comb) as prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,nvl(n.risk_asset_comb, o.risk_asset_comb) as risk_asset_comb -- 风险资产组合
    ,nvl(n.prop_descb, o.prop_descb) as prop_descb -- 方案描述
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移标识
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.up_date, o.up_date) as up_date -- 更新日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ap_handle_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_ap_handle_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.prop_id <> n.prop_id
        or o.prop_name <> n.prop_name
        or o.del_flg <> n.del_flg
        or o.apedx_id <> n.apedx_id
        or o.prop_kind_id <> n.prop_kind_id
        or o.main_disp_type_cd <> n.main_disp_type_cd
        or o.disp_type_cd <> n.disp_type_cd
        or o.subrch_prvlg_flg <> n.subrch_prvlg_flg
        or o.reply_id <> n.reply_id
        or o.reply_content_descb <> n.reply_content_descb
        or o.reply_input_dt <> n.reply_input_dt
        or o.apv_status_cd <> n.apv_status_cd
        or o.disp_amt <> n.disp_amt
        or o.rpbl_pric_amt <> n.rpbl_pric_amt
        or o.rpbl_in_bs_int_amt <> n.rpbl_in_bs_int_amt
        or o.rpbl_off_bs_int_amt <> n.rpbl_off_bs_int_amt
        or o.derate_pric_amt <> n.derate_pric_amt
        or o.derate_tot_amt <> n.derate_tot_amt
        or o.derate_in_bs_int_amt <> n.derate_in_bs_int_amt
        or o.derate_off_bs_int_amt <> n.derate_off_bs_int_amt
        or o.derate_bf_pric_bal <> n.derate_bf_pric_bal
        or o.derate_bf_in_bs_over_int_amt <> n.derate_bf_in_bs_over_int_amt
        or o.derate_bf_off_bs_over_int_amt <> n.derate_bf_off_bs_over_int_amt
        or o.brwer_cert_type_cd <> n.brwer_cert_type_cd
        or o.brwer_cert_no <> n.brwer_cert_no
        or o.prop_invo_trd_cust_descb <> n.prop_invo_trd_cust_descb
        or o.prop_invo_trd_cust_name_comb <> n.prop_invo_trd_cust_name_comb
        or o.prop_invo_trd_cust_id_comb <> n.prop_invo_trd_cust_id_comb
        or o.risk_asset_comb <> n.risk_asset_comb
        or o.prop_descb <> n.prop_descb
        or o.move_remark <> n.move_remark
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.up_date <> n.up_date
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ap_handle_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,del_flg -- 删除标志
    ,apedx_id -- 附件编号
    ,prop_kind_id -- 方案种类编号
    ,main_disp_type_cd -- 主处置类型代码
    ,disp_type_cd -- 处置类型代码
    ,subrch_prvlg_flg -- 分支行权限标志
    ,reply_id -- 批复编号
    ,reply_content_descb -- 批复内容描述
    ,reply_input_dt -- 批复录入日期
    ,apv_status_cd -- 审批状态代码
    ,disp_amt -- 处置金额
    ,rpbl_pric_amt -- 应还本金金额
    ,rpbl_in_bs_int_amt -- 应还表内利息金额
    ,rpbl_off_bs_int_amt -- 应还表外利息金额
    ,derate_pric_amt -- 减免本金金额
    ,derate_tot_amt -- 减免总金额
    ,derate_in_bs_int_amt -- 减免表内利息金额
    ,derate_off_bs_int_amt -- 减免表外利息金额
    ,derate_bf_pric_bal -- 减免前本金余额
    ,derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,risk_asset_comb -- 风险资产组合
    ,prop_descb -- 方案描述
    ,move_remark -- 迁移标识
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ap_handle_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,prop_id -- 方案编号
    ,prop_name -- 方案名称
    ,del_flg -- 删除标志
    ,apedx_id -- 附件编号
    ,prop_kind_id -- 方案种类编号
    ,main_disp_type_cd -- 主处置类型代码
    ,disp_type_cd -- 处置类型代码
    ,subrch_prvlg_flg -- 分支行权限标志
    ,reply_id -- 批复编号
    ,reply_content_descb -- 批复内容描述
    ,reply_input_dt -- 批复录入日期
    ,apv_status_cd -- 审批状态代码
    ,disp_amt -- 处置金额
    ,rpbl_pric_amt -- 应还本金金额
    ,rpbl_in_bs_int_amt -- 应还表内利息金额
    ,rpbl_off_bs_int_amt -- 应还表外利息金额
    ,derate_pric_amt -- 减免本金金额
    ,derate_tot_amt -- 减免总金额
    ,derate_in_bs_int_amt -- 减免表内利息金额
    ,derate_off_bs_int_amt -- 减免表外利息金额
    ,derate_bf_pric_bal -- 减免前本金余额
    ,derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,brwer_cert_type_cd -- 借款人证件类型代码
    ,brwer_cert_no -- 借款人证件号码
    ,prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,risk_asset_comb -- 风险资产组合
    ,prop_descb -- 方案描述
    ,move_remark -- 迁移标识
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,up_date -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.prop_id -- 方案编号
    ,o.prop_name -- 方案名称
    ,o.del_flg -- 删除标志
    ,o.apedx_id -- 附件编号
    ,o.prop_kind_id -- 方案种类编号
    ,o.main_disp_type_cd -- 主处置类型代码
    ,o.disp_type_cd -- 处置类型代码
    ,o.subrch_prvlg_flg -- 分支行权限标志
    ,o.reply_id -- 批复编号
    ,o.reply_content_descb -- 批复内容描述
    ,o.reply_input_dt -- 批复录入日期
    ,o.apv_status_cd -- 审批状态代码
    ,o.disp_amt -- 处置金额
    ,o.rpbl_pric_amt -- 应还本金金额
    ,o.rpbl_in_bs_int_amt -- 应还表内利息金额
    ,o.rpbl_off_bs_int_amt -- 应还表外利息金额
    ,o.derate_pric_amt -- 减免本金金额
    ,o.derate_tot_amt -- 减免总金额
    ,o.derate_in_bs_int_amt -- 减免表内利息金额
    ,o.derate_off_bs_int_amt -- 减免表外利息金额
    ,o.derate_bf_pric_bal -- 减免前本金余额
    ,o.derate_bf_in_bs_over_int_amt -- 减免前表内欠息金额
    ,o.derate_bf_off_bs_over_int_amt -- 减免前表外欠息金额
    ,o.brwer_cert_type_cd -- 借款人证件类型代码
    ,o.brwer_cert_no -- 借款人证件号码
    ,o.prop_invo_trd_cust_descb -- 方案涉及第三客户描述
    ,o.prop_invo_trd_cust_name_comb -- 方案涉及第三客户名称组合
    ,o.prop_invo_trd_cust_id_comb -- 方案涉及第三客户编号组合
    ,o.risk_asset_comb -- 风险资产组合
    ,o.prop_descb -- 方案描述
    ,o.move_remark -- 迁移标识
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
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
from ${iml_schema}.agt_ap_handle_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_ap_handle_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ap_handle_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ap_handle_info_h;
--alter table ${iml_schema}.agt_ap_handle_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ap_handle_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ap_handle_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ap_handle_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ap_handle_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_ap_handle_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_ap_handle_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_ap_handle_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ap_handle_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ap_handle_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_ap_handle_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_ap_handle_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ap_handle_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ap_handle_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);

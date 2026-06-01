/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ap_handle_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ap_handle_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ap_handle_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ap_handle_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,prop_id varchar2(100) -- 方案编号
    ,prop_name varchar2(1000) -- 方案名称
    ,del_flg varchar2(30) -- 删除标志
    ,apedx_id varchar2(100) -- 附件编号
    ,prop_kind_id varchar2(100) -- 方案种类编号
    ,main_disp_type_cd varchar2(30) -- 主处置类型代码
    ,disp_type_cd varchar2(250) -- 处置类型代码
    ,subrch_prvlg_flg varchar2(30) -- 分支行权限标志
    ,reply_id varchar2(100) -- 批复编号
    ,reply_content_descb varchar2(4000) -- 批复内容描述
    ,reply_input_dt date -- 批复录入日期
    ,apv_status_cd varchar2(30) -- 审批状态代码
    ,disp_amt number(30,8) -- 处置金额
    ,rpbl_pric_amt number(30,8) -- 应还本金金额
    ,rpbl_in_bs_int_amt number(30,8) -- 应还表内利息金额
    ,rpbl_off_bs_int_amt number(30,8) -- 应还表外利息金额
    ,derate_pric_amt number(30,8) -- 减免本金金额
    ,derate_tot_amt number(30,8) -- 减免总金额
    ,derate_in_bs_int_amt number(30,8) -- 减免表内利息金额
    ,derate_off_bs_int_amt number(30,8) -- 减免表外利息金额
    ,derate_bf_pric_bal number(30,8) -- 减免前本金余额
    ,derate_bf_in_bs_over_int_amt number(30,8) -- 减免前表内欠息金额
    ,derate_bf_off_bs_over_int_amt number(30,8) -- 减免前表外欠息金额
    ,brwer_cert_type_cd varchar2(30) -- 借款人证件类型代码
    ,brwer_cert_no varchar2(60) -- 借款人证件号码
    ,prop_invo_trd_cust_descb varchar2(250) -- 方案涉及第三客户描述
    ,prop_invo_trd_cust_name_comb varchar2(1000) -- 方案涉及第三客户名称组合
    ,prop_invo_trd_cust_id_comb varchar2(250) -- 方案涉及第三客户编号组合
    ,risk_asset_comb varchar2(2000) -- 风险资产组合
    ,prop_descb varchar2(4000) -- 方案描述
    ,move_remark varchar2(500) -- 迁移标识
    ,remark varchar2(4000) -- 备注
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,up_date date -- 更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_ap_handle_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_ap_handle_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_ap_handle_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ap_handle_info_h is '问题资产处置信息历史';
comment on column ${iml_schema}.agt_ap_handle_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.prop_id is '方案编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.prop_name is '方案名称';
comment on column ${iml_schema}.agt_ap_handle_info_h.del_flg is '删除标志';
comment on column ${iml_schema}.agt_ap_handle_info_h.apedx_id is '附件编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.prop_kind_id is '方案种类编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.main_disp_type_cd is '主处置类型代码';
comment on column ${iml_schema}.agt_ap_handle_info_h.disp_type_cd is '处置类型代码';
comment on column ${iml_schema}.agt_ap_handle_info_h.subrch_prvlg_flg is '分支行权限标志';
comment on column ${iml_schema}.agt_ap_handle_info_h.reply_id is '批复编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.reply_content_descb is '批复内容描述';
comment on column ${iml_schema}.agt_ap_handle_info_h.reply_input_dt is '批复录入日期';
comment on column ${iml_schema}.agt_ap_handle_info_h.apv_status_cd is '审批状态代码';
comment on column ${iml_schema}.agt_ap_handle_info_h.disp_amt is '处置金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.rpbl_pric_amt is '应还本金金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.rpbl_in_bs_int_amt is '应还表内利息金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.rpbl_off_bs_int_amt is '应还表外利息金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.derate_pric_amt is '减免本金金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.derate_tot_amt is '减免总金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.derate_in_bs_int_amt is '减免表内利息金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.derate_off_bs_int_amt is '减免表外利息金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.derate_bf_pric_bal is '减免前本金余额';
comment on column ${iml_schema}.agt_ap_handle_info_h.derate_bf_in_bs_over_int_amt is '减免前表内欠息金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.derate_bf_off_bs_over_int_amt is '减免前表外欠息金额';
comment on column ${iml_schema}.agt_ap_handle_info_h.brwer_cert_type_cd is '借款人证件类型代码';
comment on column ${iml_schema}.agt_ap_handle_info_h.brwer_cert_no is '借款人证件号码';
comment on column ${iml_schema}.agt_ap_handle_info_h.prop_invo_trd_cust_descb is '方案涉及第三客户描述';
comment on column ${iml_schema}.agt_ap_handle_info_h.prop_invo_trd_cust_name_comb is '方案涉及第三客户名称组合';
comment on column ${iml_schema}.agt_ap_handle_info_h.prop_invo_trd_cust_id_comb is '方案涉及第三客户编号组合';
comment on column ${iml_schema}.agt_ap_handle_info_h.risk_asset_comb is '风险资产组合';
comment on column ${iml_schema}.agt_ap_handle_info_h.prop_descb is '方案描述';
comment on column ${iml_schema}.agt_ap_handle_info_h.move_remark is '迁移标识';
comment on column ${iml_schema}.agt_ap_handle_info_h.remark is '备注';
comment on column ${iml_schema}.agt_ap_handle_info_h.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_ap_handle_info_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.agt_ap_handle_info_h.up_date is '更新日期';
comment on column ${iml_schema}.agt_ap_handle_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_ap_handle_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_ap_handle_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ap_handle_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ap_handle_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ap_handle_info_h.etl_timestamp is 'ETL处理时间戳';

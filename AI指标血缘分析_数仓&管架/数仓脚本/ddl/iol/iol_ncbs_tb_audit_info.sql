/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_audit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_audit_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_audit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_audit_info(
    voucher_tailbox_id varchar2(30) -- 凭证尾箱编号
    ,client_no varchar2(16) -- 客户编号
    ,remark varchar2(600) -- 备注
    ,audit_id varchar2(50) -- 查库编号
    ,cash_check_result varchar2(5) -- 现金检查结果
    ,cash_tailbox_id varchar2(50) -- 现金尾箱
    ,check_user_post varchar2(30) -- 检查人职务
    ,company varchar2(20) -- 法人
    ,custody_product_check_result varchar2(5) -- 代保管品检查结果
    ,fake_money_check_result varchar2(5) -- 假币检查结果
    ,item_check_result varchar2(1) -- 重要物品检查结果
    ,main_check_user_post varchar2(50) -- 主检查人职务
    ,total_cash_check_result varchar2(1) -- 现金汇总检查结果
    ,voucher_check_result varchar2(5) -- 凭证检查结果
    ,audit_date date -- 审计日期
    ,audit_timestamp varchar2(26) -- 审计时间
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,censored_branch varchar2(12) -- 被查人机构
    ,censored_user_id varchar2(8) -- 被查人
    ,check_user_name varchar2(200) -- 检查人姓名
    ,check_user_org varchar2(12) -- 检查人机构
    ,current_user_id varchar2(8) -- 当前操作柜员
    ,main_check_user_name varchar2(200) -- 主检查人姓名
    ,main_check_user_org varchar2(12) -- 主检查人机构
    ,assistant_user_id2 varchar2(8) -- 协查人2
    ,check_user_id1 varchar2(50) -- 检查人1
    ,audit_check_type varchar2(10) -- 查库类型
    ,assistant_user_id1 varchar2(8) -- 协查人1
    ,check_user_id2 varchar2(50) -- 检查人2
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_tb_audit_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_audit_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_audit_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_audit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_audit_info is '审计查库结果登记表';
comment on column ${iol_schema}.ncbs_tb_audit_info.voucher_tailbox_id is '凭证尾箱编号';
comment on column ${iol_schema}.ncbs_tb_audit_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_audit_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_audit_info.audit_id is '查库编号';
comment on column ${iol_schema}.ncbs_tb_audit_info.cash_check_result is '现金检查结果';
comment on column ${iol_schema}.ncbs_tb_audit_info.cash_tailbox_id is '现金尾箱';
comment on column ${iol_schema}.ncbs_tb_audit_info.check_user_post is '检查人职务';
comment on column ${iol_schema}.ncbs_tb_audit_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_audit_info.custody_product_check_result is '代保管品检查结果';
comment on column ${iol_schema}.ncbs_tb_audit_info.fake_money_check_result is '假币检查结果';
comment on column ${iol_schema}.ncbs_tb_audit_info.item_check_result is '重要物品检查结果';
comment on column ${iol_schema}.ncbs_tb_audit_info.main_check_user_post is '主检查人职务';
comment on column ${iol_schema}.ncbs_tb_audit_info.total_cash_check_result is '现金汇总检查结果';
comment on column ${iol_schema}.ncbs_tb_audit_info.voucher_check_result is '凭证检查结果';
comment on column ${iol_schema}.ncbs_tb_audit_info.audit_date is '审计日期';
comment on column ${iol_schema}.ncbs_tb_audit_info.audit_timestamp is '审计时间';
comment on column ${iol_schema}.ncbs_tb_audit_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_audit_info.censored_branch is '被查人机构';
comment on column ${iol_schema}.ncbs_tb_audit_info.censored_user_id is '被查人';
comment on column ${iol_schema}.ncbs_tb_audit_info.check_user_name is '检查人姓名';
comment on column ${iol_schema}.ncbs_tb_audit_info.check_user_org is '检查人机构';
comment on column ${iol_schema}.ncbs_tb_audit_info.current_user_id is '当前操作柜员';
comment on column ${iol_schema}.ncbs_tb_audit_info.main_check_user_name is '主检查人姓名';
comment on column ${iol_schema}.ncbs_tb_audit_info.main_check_user_org is '主检查人机构';
comment on column ${iol_schema}.ncbs_tb_audit_info.assistant_user_id2 is '协查人2';
comment on column ${iol_schema}.ncbs_tb_audit_info.check_user_id1 is '检查人1';
comment on column ${iol_schema}.ncbs_tb_audit_info.audit_check_type is '查库类型';
comment on column ${iol_schema}.ncbs_tb_audit_info.assistant_user_id1 is '协查人1';
comment on column ${iol_schema}.ncbs_tb_audit_info.check_user_id2 is '检查人2';
comment on column ${iol_schema}.ncbs_tb_audit_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_audit_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_audit_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_audit_info.etl_timestamp is 'ETL处理时间戳';

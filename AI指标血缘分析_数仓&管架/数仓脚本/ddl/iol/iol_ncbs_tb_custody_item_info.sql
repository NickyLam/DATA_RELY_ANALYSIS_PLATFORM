/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_custody_item_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_custody_item_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_custody_item_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_custody_item_info(
    amount number(17,2) -- 金额
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,remark varchar2(1000) -- 备注
    ,agent_tel varchar2(20) -- 经办人电话
    ,company varchar2(20) -- 法人
    ,company_name varchar2(50) -- 公司名称
    ,contact_tel varchar2(20) -- 客户联系电话
    ,custody_item_num number(5) -- 代保管物品数量
    ,custody_item_status varchar2(1) -- 代保管物品状态
    ,custody_type varchar2(150) -- 代保管品种类
    ,draw_man varchar2(30) -- 领取人
    ,item_id varchar2(50) -- 物品编号
    ,phone varchar2(20) -- 手机号
    ,store_person varchar2(50) -- 存放人
    ,delete_date date -- 删除日期
    ,handover_date date -- 交接日期
    ,in_date date -- 入库日期
    ,out_date date -- 出库日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
    ,appr_user_id varchar2(8) -- 复核柜员
    ,belong_user_id varchar2(8) -- 所属柜员
    ,in_user_id varchar2(8) -- 入库柜员
    ,last_branch_id varchar2(12) -- 上一所属机构
    ,last_user_id varchar2(8) -- 上一柜员id
    ,out_user_id varchar2(8) -- 出库交易柜员
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,custody_sub_type varchar2(10) -- 代保管物品大类
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
grant select on ${iol_schema}.ncbs_tb_custody_item_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_custody_item_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_custody_item_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_custody_item_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_custody_item_info is '代保管物品管理信息表';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.amount is '金额';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.agent_tel is '经办人电话';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.company_name is '公司名称';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.contact_tel is '客户联系电话';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.custody_item_num is '代保管物品数量';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.custody_item_status is '代保管物品状态';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.custody_type is '代保管品种类';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.draw_man is '领取人';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.item_id is '物品编号';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.phone is '手机号';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.store_person is '存放人';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.delete_date is '删除日期';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.handover_date is '交接日期';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.in_date is '入库日期';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.out_date is '出库日期';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.belong_user_id is '所属柜员';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.in_user_id is '入库柜员';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.last_branch_id is '上一所属机构';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.last_user_id is '上一柜员id';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.out_user_id is '出库交易柜员';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.custody_sub_type is '代保管物品大类';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_custody_item_info.etl_timestamp is 'ETL处理时间戳';

/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_blank_sign_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_blank_sign_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_blank_sign_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_blank_sign_info(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,voucher_no varchar2(50) -- 凭证号码
    ,borrow_id varchar2(50) -- 借出序号
    ,borrow_narrative varchar2(200) -- 外借备注
    ,borrow_no varchar2(50) -- 借出批次
    ,company varchar2(20) -- 法人
    ,oper_narrative varchar2(400) -- 操作备注
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,voucher_prefix varchar2(10) -- 凭证前缀
    ,voucher_tran_status varchar2(1) -- 凭证交易状态
    ,borrow_date date -- 外借日期（借出的外借日期）
    ,oper_date date -- 操作日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,borrow_branch varchar2(12) -- 外借机构（借出时的外借机构）
    ,borrow_user_id varchar2(8) -- 外借柜员（借出的外借柜员）
    ,lend_user_id varchar2(8) -- 借出柜员
    ,oper_borrow_user_id varchar2(8) -- 操作外借柜员
    ,oper_user_id varchar2(8) -- 操作柜员
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
grant select on ${iol_schema}.ncbs_tb_blank_sign_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_blank_sign_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_blank_sign_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_blank_sign_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_blank_sign_info is '预留空白印鉴卡登记簿';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.borrow_id is '借出序号';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.borrow_narrative is '外借备注';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.borrow_no is '借出批次';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.oper_narrative is '操作备注';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.voucher_prefix is '凭证前缀';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.voucher_tran_status is '凭证交易状态';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.borrow_date is '外借日期（借出的外借日期）';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.oper_date is '操作日期';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.borrow_branch is '外借机构（借出时的外借机构）';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.borrow_user_id is '外借柜员（借出的外借柜员）';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.lend_user_id is '借出柜员';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.oper_borrow_user_id is '操作外借柜员';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.oper_user_id is '操作柜员';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_blank_sign_info.etl_timestamp is 'ETL处理时间戳';

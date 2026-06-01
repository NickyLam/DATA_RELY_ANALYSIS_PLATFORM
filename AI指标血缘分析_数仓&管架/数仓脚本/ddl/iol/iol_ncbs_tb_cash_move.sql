/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_move
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_move
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_move purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_move(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,voucher_no varchar2(50) -- 凭证号码
    ,acs_flag varchar2(1) -- 人行联网取现标志
    ,company varchar2(20) -- 法人
    ,from_tailbox_id varchar2(30) -- 转出尾箱代号
    ,move_id varchar2(30) -- 调拨转移id
    ,move_type varchar2(3) -- 转移类型
    ,prefix varchar2(10) -- 前缀
    ,to_tailbox_id varchar2(30) -- 对方尾箱
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,contra_client_no varchar2(16) -- 对方客户号
    ,from_user_id varchar2(8) -- 分配/清机柜员
    ,oth_reference varchar2(50) -- 对方交易参考号
    ,to_branch varchar2(12) -- 对方机构
    ,to_user_id varchar2(8) -- 对方柜员
    ,from_branch varchar2(12) -- 转出机构
    ,contra_branch_type varchar2(1) -- 对方机构类型
    ,move_status varchar2(1) -- 转移状态
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
grant select on ${iol_schema}.ncbs_tb_cash_move to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_move is '现金转移表';
comment on column ${iol_schema}.ncbs_tb_cash_move.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_tb_cash_move.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_tb_cash_move.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_tb_cash_move.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_cash_move.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_cash_move.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_tb_cash_move.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_cash_move.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_cash_move.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_tb_cash_move.acs_flag is '人行联网取现标志';
comment on column ${iol_schema}.ncbs_tb_cash_move.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_move.from_tailbox_id is '转出尾箱代号';
comment on column ${iol_schema}.ncbs_tb_cash_move.move_id is '调拨转移id';
comment on column ${iol_schema}.ncbs_tb_cash_move.move_type is '转移类型';
comment on column ${iol_schema}.ncbs_tb_cash_move.prefix is '前缀';
comment on column ${iol_schema}.ncbs_tb_cash_move.to_tailbox_id is '对方尾箱';
comment on column ${iol_schema}.ncbs_tb_cash_move.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_tb_cash_move.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_cash_move.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_move.contra_client_no is '对方客户号';
comment on column ${iol_schema}.ncbs_tb_cash_move.from_user_id is '分配/清机柜员';
comment on column ${iol_schema}.ncbs_tb_cash_move.oth_reference is '对方交易参考号';
comment on column ${iol_schema}.ncbs_tb_cash_move.to_branch is '对方机构';
comment on column ${iol_schema}.ncbs_tb_cash_move.to_user_id is '对方柜员';
comment on column ${iol_schema}.ncbs_tb_cash_move.from_branch is '转出机构';
comment on column ${iol_schema}.ncbs_tb_cash_move.contra_branch_type is '对方机构类型';
comment on column ${iol_schema}.ncbs_tb_cash_move.move_status is '转移状态';
comment on column ${iol_schema}.ncbs_tb_cash_move.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_move.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_move.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_move.etl_timestamp is 'ETL处理时间戳';

/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_eqpt_voucher_mistake
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_eqpt_voucher_mistake
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_eqpt_voucher_mistake purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_eqpt_voucher_mistake(
    doc_type varchar2(10) -- 凭证类型
    ,voucher_no varchar2(50) -- 凭证号码
    ,company varchar2(20) -- 法人
    ,deal_flag varchar2(1) -- 处理标识
    ,from_tailbox_id varchar2(30) -- 转出尾箱代号
    ,mistake_type varchar2(1) -- 凭证差错类型
    ,to_tailbox_id varchar2(30) -- 对方尾箱
    ,voucher_move_id varchar2(30) -- 凭证转移id
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,deal_reason varchar2(200) -- 处理说明
    ,from_user_id varchar2(8) -- 分配/清机柜员
    ,to_branch varchar2(12) -- 对方机构
    ,to_user_id varchar2(8) -- 对方柜员
    ,from_branch varchar2(12) -- 转出机构
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
grant select on ${iol_schema}.ncbs_tb_eqpt_voucher_mistake to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_voucher_mistake to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_voucher_mistake to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_voucher_mistake to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_eqpt_voucher_mistake is '自助设备凭证清机上缴差错表';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.company is '法人';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.deal_flag is '处理标识';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.from_tailbox_id is '转出尾箱代号';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.mistake_type is '凭证差错类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.to_tailbox_id is '对方尾箱';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.voucher_move_id is '凭证转移id';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.deal_reason is '处理说明';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.from_user_id is '分配/清机柜员';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.to_branch is '对方机构';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.to_user_id is '对方柜员';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.from_branch is '转出机构';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_voucher_mistake.etl_timestamp is 'ETL处理时间戳';

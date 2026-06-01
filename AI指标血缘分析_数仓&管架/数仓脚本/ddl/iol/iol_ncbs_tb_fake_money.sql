/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_fake_money
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_fake_money
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_fake_money purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_fake_money(
    ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,remark varchar2(600) -- 备注
    ,bond_number number(5) -- 套数
    ,bond_version_num varchar2(20) -- 版别
    ,company varchar2(20) -- 法人
    ,fake_ccy_no varchar2(50) -- 假币冠字号码
    ,fake_money_status varchar2(1) -- 假币状态
    ,fake_num number(5) -- 假币张数
    ,make_type varchar2(1) -- 制作方式
    ,par_value_id varchar2(20) -- 券别代码
    ,seq_no varchar2(50) -- 序号
    ,turn_over_branch varchar2(12) -- 上缴人行机构
    ,capture_date date -- 收缴日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,belong_user_id varchar2(8) -- 所属柜员
    ,capture_branch varchar2(12) -- 收缴机构
    ,capture_user_id varchar2(8) -- 收缴柜员
    ,fake_amt number(17,2) -- 假币账面金额
    ,holder_global_id varchar2(60) -- 持有人证件号码
    ,holder_global_type varchar2(4) -- 持有人证件类型
    ,holder_name varchar2(200) -- 持有人名称
    ,turn_over_date date -- 上缴人行日期
    ,turn_over_user_id varchar2(30) -- 上缴人行柜员
    ,belong_branch varchar2(12) -- 归属机构
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
grant select on ${iol_schema}.ncbs_tb_fake_money to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_fake_money to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_fake_money to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_fake_money to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_fake_money is '假币管理';
comment on column ${iol_schema}.ncbs_tb_fake_money.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_fake_money.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_tb_fake_money.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_fake_money.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_fake_money.bond_number is '套数';
comment on column ${iol_schema}.ncbs_tb_fake_money.bond_version_num is '版别';
comment on column ${iol_schema}.ncbs_tb_fake_money.company is '法人';
comment on column ${iol_schema}.ncbs_tb_fake_money.fake_ccy_no is '假币冠字号码';
comment on column ${iol_schema}.ncbs_tb_fake_money.fake_money_status is '假币状态';
comment on column ${iol_schema}.ncbs_tb_fake_money.fake_num is '假币张数';
comment on column ${iol_schema}.ncbs_tb_fake_money.make_type is '制作方式';
comment on column ${iol_schema}.ncbs_tb_fake_money.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_fake_money.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_fake_money.turn_over_branch is '上缴人行机构';
comment on column ${iol_schema}.ncbs_tb_fake_money.capture_date is '收缴日期';
comment on column ${iol_schema}.ncbs_tb_fake_money.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_fake_money.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_tb_fake_money.belong_user_id is '所属柜员';
comment on column ${iol_schema}.ncbs_tb_fake_money.capture_branch is '收缴机构';
comment on column ${iol_schema}.ncbs_tb_fake_money.capture_user_id is '收缴柜员';
comment on column ${iol_schema}.ncbs_tb_fake_money.fake_amt is '假币账面金额';
comment on column ${iol_schema}.ncbs_tb_fake_money.holder_global_id is '持有人证件号码';
comment on column ${iol_schema}.ncbs_tb_fake_money.holder_global_type is '持有人证件类型';
comment on column ${iol_schema}.ncbs_tb_fake_money.holder_name is '持有人名称';
comment on column ${iol_schema}.ncbs_tb_fake_money.turn_over_date is '上缴人行日期';
comment on column ${iol_schema}.ncbs_tb_fake_money.turn_over_user_id is '上缴人行柜员';
comment on column ${iol_schema}.ncbs_tb_fake_money.belong_branch is '归属机构';
comment on column ${iol_schema}.ncbs_tb_fake_money.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_fake_money.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_fake_money.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_fake_money.etl_timestamp is 'ETL处理时间戳';

/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_pir_adm_pay_ele_channel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_pir_adm_pay_ele_channel
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_pir_adm_pay_ele_channel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_pir_adm_pay_ele_channel(
    data_dt varchar2(15) -- 数据日期
    ,org_num varchar2(18) -- 机构号
    ,tran_typ varchar2(2) -- 交易类型
    ,tran_num number(18,0) -- 交易笔数
    ,tran_amt number(18,4) -- 交易金额
    ,overbank_flg varchar2(2) -- 是否跨行
    ,cust_typ varchar2(2) -- 客户类型
    ,pos_bus_typ varchar2(2) -- pos签约商户行业代码
    ,pos_typ varchar2(2) -- pos业务类型2013-12-09增加
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
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_channel to ${iml_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_channel to ${icl_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_channel to ${idl_schema};
grant select on ${iol_schema}.ifcs_pir_adm_pay_ele_channel to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_pir_adm_pay_ele_channel is '电子渠道交易汇总表';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.data_dt is '数据日期';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.org_num is '机构号';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.tran_typ is '交易类型';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.tran_num is '交易笔数';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.tran_amt is '交易金额';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.overbank_flg is '是否跨行';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.cust_typ is '客户类型';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.pos_bus_typ is 'pos签约商户行业代码';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.pos_typ is 'pos业务类型2013-12-09增加';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.start_dt is '开始时间';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.end_dt is '结束时间';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.id_mark is '增删标志';
comment on column ${iol_schema}.ifcs_pir_adm_pay_ele_channel.etl_timestamp is 'ETL处理时间戳';

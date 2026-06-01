/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_alrdyclsgdbtctnsmyinf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,astdsp_bsn_acc number(22) -- 资产处置业务账户数:eb02bs01
    ,astdsp_bsn_bal number(38,0) -- 资产处置业务余额:eb02bj01
    ,displ_compl_dt date -- 处置完成日期:eb02br01
    ,clsg_dt date -- 结清日期:eb02br02
    ,adcsh_bsn_acc number(22) -- 垫款业务账户数:eb02bs02
    ,adcsh_bsn_bal number(38,0) -- 垫款业务余额:eb02bj02
    ,othrdbtcrtclsyentrnum number(22) -- 其他借贷交易分类汇总条目数量:eb02bs03
    ,crt_dt_tm date -- 创建日期时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf is '已结清借贷交易汇总信息';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.astdsp_bsn_acc is '资产处置业务账户数:eb02bs01';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.astdsp_bsn_bal is '资产处置业务余额:eb02bj01';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.displ_compl_dt is '处置完成日期:eb02br01';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.clsg_dt is '结清日期:eb02br02';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.adcsh_bsn_acc is '垫款业务账户数:eb02bs02';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.adcsh_bsn_bal is '垫款业务余额:eb02bj02';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.othrdbtcrtclsyentrnum is '其他借贷交易分类汇总条目数量:eb02bs03';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_alrdyclsgdbtctnsmyinf.etl_timestamp is 'ETL处理时间戳';

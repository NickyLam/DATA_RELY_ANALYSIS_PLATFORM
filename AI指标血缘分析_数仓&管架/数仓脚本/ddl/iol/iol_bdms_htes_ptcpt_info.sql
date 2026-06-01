/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_htes_ptcpt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_htes_ptcpt_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_htes_ptcpt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_htes_ptcpt_info(
    id varchar2(60) -- ID
    ,bank_no varchar2(21) -- 参与机构行号
    ,actor_type varchar2(3) -- 参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
    ,bank_other_code varchar2(5) -- 行别代码
    ,belong_bank_no varchar2(21) -- 所属直参行号
    ,belong_legal_no varchar2(21) -- 所属法人
    ,up_actor_no varchar2(315) -- 本行上级参与机构
    ,recept_bank_no varchar2(21) -- 承接行行号
    ,cate_people_code varchar2(21) -- 管辖人行行号
    ,ccpc_code varchar2(6) -- 所属CCPC
    ,city_code varchar2(9) -- 所在城市代码
    ,bank_name varchar2(180) -- 参与机构全称
    ,tel_phone varchar2(675) -- 电话或电挂
    ,jion_flag varchar2(6) -- 加入人行大额业务系统标识
    ,effect_type varchar2(12) -- 生效类型： EF00 立即生效 EF01 指定日期生效
    ,effect_date varchar2(12) -- 生效日期
    ,expire_date varchar2(12) -- 失效日期
    ,cert_status varchar2(3) -- 证书绑定状态： 00 未绑定 01 已绑定
    ,refer_code varchar2(300) -- 参考码
    ,auth_code varchar2(300) -- 授权码
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,create_by varchar2(45) -- 创建人
    ,create_time varchar2(21) -- 创建时间
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
grant select on ${iol_schema}.bdms_htes_ptcpt_info to ${iml_schema};
grant select on ${iol_schema}.bdms_htes_ptcpt_info to ${icl_schema};
grant select on ${iol_schema}.bdms_htes_ptcpt_info to ${idl_schema};
grant select on ${iol_schema}.bdms_htes_ptcpt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_htes_ptcpt_info is '支付系统行名行号表';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.id is 'ID';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.bank_no is '参与机构行号';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.actor_type is '参与机构类别： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.bank_other_code is '行别代码';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.belong_bank_no is '所属直参行号';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.belong_legal_no is '所属法人';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.up_actor_no is '本行上级参与机构';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.recept_bank_no is '承接行行号';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.cate_people_code is '管辖人行行号';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.ccpc_code is '所属CCPC';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.city_code is '所在城市代码';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.bank_name is '参与机构全称';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.tel_phone is '电话或电挂';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.jion_flag is '加入人行大额业务系统标识';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.effect_type is '生效类型： EF00 立即生效 EF01 指定日期生效';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.effect_date is '生效日期';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.expire_date is '失效日期';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.cert_status is '证书绑定状态： 00 未绑定 01 已绑定';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.refer_code is '参考码';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.auth_code is '授权码';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_htes_ptcpt_info.etl_timestamp is 'ETL处理时间戳';

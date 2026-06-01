/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_union_bank_hxty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_union_bank_hxty
whenever sqlerror continue none;
drop table ${iol_schema}.icms_union_bank_hxty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_union_bank_hxty(
    id varchar2(40) -- 票据系统ID
    ,belong_bank_no varchar2(14) -- 所属直参行号
    ,expire_date date -- 失效日期
    ,migtflag varchar2(80) -- 
    ,ccpc_code varchar2(4) -- 所属CCPC
    ,tel_phone varchar2(450) -- 电话或电挂
    ,city_code varchar2(6) -- 所在城市代码
    ,effect_type varchar2(8) -- 生效类型： EF00立即生效 EF01指定日期生效
    ,bank_name varchar2(120) -- 参与机构全称
    ,bank_other_code varchar2(3) -- 行别代码
    ,updatetime date -- 更新日期
    ,up_actor_no varchar2(210) -- 本行上级参与机构
    ,jion_flag varchar2(4) -- 加入人行大额业务系统标识
    ,bank_no varchar2(14) -- 参与机构行号
    ,recept_bank_no varchar2(14) -- 承接行行号
    ,cate_people_code varchar2(14) -- 管辖人行行号
    ,actor_type varchar2(2) -- 参与机构类别： 01直接参与人行 02直接参与国库 03EIS转换中心 04直接参与商业银行 05开户特许直接参与者 06开户特许间接参与者 07间接参与者 08无户特许直接参与者(债券)
    ,inputtime date -- 录入日期
    ,belong_legal_no varchar2(14) -- 所属法人
    ,effect_date date -- 生效日期
    ,etl_dt_ora date -- 跑批日期
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
grant select on ${iol_schema}.icms_union_bank_hxty to ${iml_schema};
grant select on ${iol_schema}.icms_union_bank_hxty to ${icl_schema};
grant select on ${iol_schema}.icms_union_bank_hxty to ${idl_schema};
grant select on ${iol_schema}.icms_union_bank_hxty to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_union_bank_hxty is '同业联行信息表';
comment on column ${iol_schema}.icms_union_bank_hxty.id is '票据系统ID';
comment on column ${iol_schema}.icms_union_bank_hxty.belong_bank_no is '所属直参行号';
comment on column ${iol_schema}.icms_union_bank_hxty.expire_date is '失效日期';
comment on column ${iol_schema}.icms_union_bank_hxty.migtflag is '';
comment on column ${iol_schema}.icms_union_bank_hxty.ccpc_code is '所属CCPC';
comment on column ${iol_schema}.icms_union_bank_hxty.tel_phone is '电话或电挂';
comment on column ${iol_schema}.icms_union_bank_hxty.city_code is '所在城市代码';
comment on column ${iol_schema}.icms_union_bank_hxty.effect_type is '生效类型： EF00立即生效 EF01指定日期生效';
comment on column ${iol_schema}.icms_union_bank_hxty.bank_name is '参与机构全称';
comment on column ${iol_schema}.icms_union_bank_hxty.bank_other_code is '行别代码';
comment on column ${iol_schema}.icms_union_bank_hxty.updatetime is '更新日期';
comment on column ${iol_schema}.icms_union_bank_hxty.up_actor_no is '本行上级参与机构';
comment on column ${iol_schema}.icms_union_bank_hxty.jion_flag is '加入人行大额业务系统标识';
comment on column ${iol_schema}.icms_union_bank_hxty.bank_no is '参与机构行号';
comment on column ${iol_schema}.icms_union_bank_hxty.recept_bank_no is '承接行行号';
comment on column ${iol_schema}.icms_union_bank_hxty.cate_people_code is '管辖人行行号';
comment on column ${iol_schema}.icms_union_bank_hxty.actor_type is '参与机构类别： 01直接参与人行 02直接参与国库 03EIS转换中心 04直接参与商业银行 05开户特许直接参与者 06开户特许间接参与者 07间接参与者 08无户特许直接参与者(债券)';
comment on column ${iol_schema}.icms_union_bank_hxty.inputtime is '录入日期';
comment on column ${iol_schema}.icms_union_bank_hxty.belong_legal_no is '所属法人';
comment on column ${iol_schema}.icms_union_bank_hxty.effect_date is '生效日期';
comment on column ${iol_schema}.icms_union_bank_hxty.etl_dt_ora is '跑批日期';
comment on column ${iol_schema}.icms_union_bank_hxty.start_dt is '开始时间';
comment on column ${iol_schema}.icms_union_bank_hxty.end_dt is '结束时间';
comment on column ${iol_schema}.icms_union_bank_hxty.id_mark is '增删标志';
comment on column ${iol_schema}.icms_union_bank_hxty.etl_timestamp is 'ETL处理时间戳';

/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_capitalpurpose
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_capitalpurpose
whenever sqlerror continue none;
drop table ${iol_schema}.icms_capitalpurpose purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_capitalpurpose(
    serialno varchar2(64) -- 流水号
    ,migtflag varchar2(80) -- 
    ,overseeobjecttype varchar2(32) -- 监测对象类型
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,objectno varchar2(64) -- 对象号(借据流水号)
    ,inputdate date -- 登记日期
    ,overseeapplyserialno varchar2(64) -- 监测申请流水号
    ,isok varchar2(32) -- 是否符合合同约定（是否符合规定的贷款用途）
    ,saveflag varchar2(1) -- 保存标志（YesNo）
    ,transsum number(24,6) -- 转款金额
    ,paymenttime date -- 支付时间
    ,actualpurpose varchar2(300) -- 实际用途
    ,paymentno varchar2(40) -- 支付流水号
    ,remark varchar2(300) -- 备注
    ,paymethod varchar2(200) -- 支付方式
    ,updateuserid varchar2(64) -- 更新人编号
    ,updatedate date -- 更新日期
    ,payee varchar2(300) -- 收款人
    ,updateorgid varchar2(64) -- 更新人机构编号
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
grant select on ${iol_schema}.icms_capitalpurpose to ${iml_schema};
grant select on ${iol_schema}.icms_capitalpurpose to ${icl_schema};
grant select on ${iol_schema}.icms_capitalpurpose to ${idl_schema};
grant select on ${iol_schema}.icms_capitalpurpose to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_capitalpurpose is '风险监测-资金用途监测';
comment on column ${iol_schema}.icms_capitalpurpose.serialno is '流水号';
comment on column ${iol_schema}.icms_capitalpurpose.migtflag is '';
comment on column ${iol_schema}.icms_capitalpurpose.overseeobjecttype is '监测对象类型';
comment on column ${iol_schema}.icms_capitalpurpose.inputuserid is '登记人';
comment on column ${iol_schema}.icms_capitalpurpose.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_capitalpurpose.objectno is '对象号(借据流水号)';
comment on column ${iol_schema}.icms_capitalpurpose.inputdate is '登记日期';
comment on column ${iol_schema}.icms_capitalpurpose.overseeapplyserialno is '监测申请流水号';
comment on column ${iol_schema}.icms_capitalpurpose.isok is '是否符合合同约定（是否符合规定的贷款用途）';
comment on column ${iol_schema}.icms_capitalpurpose.saveflag is '保存标志（YesNo）';
comment on column ${iol_schema}.icms_capitalpurpose.transsum is '转款金额';
comment on column ${iol_schema}.icms_capitalpurpose.paymenttime is '支付时间';
comment on column ${iol_schema}.icms_capitalpurpose.actualpurpose is '实际用途';
comment on column ${iol_schema}.icms_capitalpurpose.paymentno is '支付流水号';
comment on column ${iol_schema}.icms_capitalpurpose.remark is '备注';
comment on column ${iol_schema}.icms_capitalpurpose.paymethod is '支付方式';
comment on column ${iol_schema}.icms_capitalpurpose.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_capitalpurpose.updatedate is '更新日期';
comment on column ${iol_schema}.icms_capitalpurpose.payee is '收款人';
comment on column ${iol_schema}.icms_capitalpurpose.updateorgid is '更新人机构编号';
comment on column ${iol_schema}.icms_capitalpurpose.start_dt is '开始时间';
comment on column ${iol_schema}.icms_capitalpurpose.end_dt is '结束时间';
comment on column ${iol_schema}.icms_capitalpurpose.id_mark is '增删标志';
comment on column ${iol_schema}.icms_capitalpurpose.etl_timestamp is 'ETL处理时间戳';

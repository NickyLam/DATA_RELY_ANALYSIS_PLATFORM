/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_asset_ins
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_asset_ins
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_asset_ins purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_asset_ins(
    serialno varchar2(64) -- 流水号
    ,updateuserid varchar2(64) -- 更新人
    ,canceldate date -- 退保日期
    ,uptodate date -- 统计截止日期
    ,updatedate date -- 更新日期
    ,piname varchar2(160) -- 保险名称
    ,inputorgid varchar2(64) -- 登记机构
    ,customerid varchar2(16) -- 客户编号
    ,underwriter varchar2(160) -- 承包公司
    ,insuredsum number(24,6) -- 保障金额保障金额（单位：元）
    ,cashvalue number(24,6) -- 现金价值现金价值（单位：元）
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,pino varchar2(64) -- 保险编号
    ,remark varchar2(1000) -- 备注
    ,begindate date -- 投保日期
    ,enddate date -- 到期日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputdate date -- 登记日期
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
grant select on ${iol_schema}.icms_ind_asset_ins to ${iml_schema};
grant select on ${iol_schema}.icms_ind_asset_ins to ${icl_schema};
grant select on ${iol_schema}.icms_ind_asset_ins to ${idl_schema};
grant select on ${iol_schema}.icms_ind_asset_ins to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_asset_ins is '财产保险财产保险情况';
comment on column ${iol_schema}.icms_ind_asset_ins.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_asset_ins.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_asset_ins.canceldate is '退保日期';
comment on column ${iol_schema}.icms_ind_asset_ins.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_asset_ins.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_asset_ins.piname is '保险名称';
comment on column ${iol_schema}.icms_ind_asset_ins.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_asset_ins.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_asset_ins.underwriter is '承包公司';
comment on column ${iol_schema}.icms_ind_asset_ins.insuredsum is '保障金额保障金额（单位：元）';
comment on column ${iol_schema}.icms_ind_asset_ins.cashvalue is '现金价值现金价值（单位：元）';
comment on column ${iol_schema}.icms_ind_asset_ins.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_asset_ins.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_asset_ins.pino is '保险编号';
comment on column ${iol_schema}.icms_ind_asset_ins.remark is '备注';
comment on column ${iol_schema}.icms_ind_asset_ins.begindate is '投保日期';
comment on column ${iol_schema}.icms_ind_asset_ins.enddate is '到期日期';
comment on column ${iol_schema}.icms_ind_asset_ins.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_asset_ins.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_asset_ins.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_asset_ins.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_asset_ins.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_asset_ins.etl_timestamp is 'ETL处理时间戳';

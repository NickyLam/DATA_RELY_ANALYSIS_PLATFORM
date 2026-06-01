/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_odebt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_odebt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_odebt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_odebt(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,debtvalue number(24,6) -- 负债余额
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,debttype varchar2(36) -- 负债类别负债类别（代码：1-现钞2-基金3-期货4-短期票券5-个人借贷(借出)6-遗产7-赠与8-赡养费9-收藏品10-家用电器11-家具12-其他）
    ,migtflag varchar2(80) -- 
    ,debtdesc varchar2(1000) -- 负债描述
    ,uptodate date -- 统计截止时间
    ,updateuserid varchar2(64) -- 更新人
    ,remark varchar2(1000) -- 备注
    ,corporgid varchar2(64) -- 法人机构编号
    ,updatedate date -- 更新日期
    ,inputuserid varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_ind_odebt to ${iml_schema};
grant select on ${iol_schema}.icms_ind_odebt to ${icl_schema};
grant select on ${iol_schema}.icms_ind_odebt to ${idl_schema};
grant select on ${iol_schema}.icms_ind_odebt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_odebt is '其他负债情况其他负债情况';
comment on column ${iol_schema}.icms_ind_odebt.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_odebt.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_odebt.debtvalue is '负债余额';
comment on column ${iol_schema}.icms_ind_odebt.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_odebt.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_odebt.debttype is '负债类别负债类别（代码：1-现钞2-基金3-期货4-短期票券5-个人借贷(借出)6-遗产7-赠与8-赡养费9-收藏品10-家用电器11-家具12-其他）';
comment on column ${iol_schema}.icms_ind_odebt.migtflag is '';
comment on column ${iol_schema}.icms_ind_odebt.debtdesc is '负债描述';
comment on column ${iol_schema}.icms_ind_odebt.uptodate is '统计截止时间';
comment on column ${iol_schema}.icms_ind_odebt.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_odebt.remark is '备注';
comment on column ${iol_schema}.icms_ind_odebt.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_odebt.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_odebt.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_odebt.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_odebt.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_odebt.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_odebt.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_odebt.etl_timestamp is 'ETL处理时间戳';

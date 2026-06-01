/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_abroad
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_abroad
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_abroad purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_abroad(
    abroadarea varchar2(30) -- 所去国家(地区)
    ,abroaddate varchar2(15) -- 出国(出境)时间
    ,abroadex varchar2(288) -- 异常情况
    ,abroadgroup varchar2(288) -- 团组名称
    ,abroadnumber varchar2(288) -- 审批文号
    ,abroadout varchar2(288) -- 派出单位
    ,abroadoutlay varchar2(288) -- 经费来源
    ,abroadpro varchar2(288) -- 审批单位
    ,abroadprodate varchar2(15) -- 审批时间
    ,abroadreturn varchar2(15) -- 回国时间
    ,abroadunit varchar2(288) -- 所去单位
    ,abroadway varchar2(30) -- 出国(出境)目的
    ,begindate varchar2(15) -- 起始日期
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,enddate varchar2(15) -- 终止日期
    ,lastflag varchar2(2) -- 最近记录标志
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,recordnum number(38,0) -- 记录序号
    ,ts varchar2(29) -- 时间戳
    ,glbdef1 varchar2(192) -- 合计天数
    ,glbdef2 varchar2(30) -- 出国（境）事由
    ,glbdef3 varchar2(30) -- 是否出具在职证明
    ,glbdef4 varchar2(192) -- 联系电话
    ,glbdef5 varchar2(192) -- 户籍地
    ,glbdef6 varchar2(15) -- 申请出国（境）时间（开始）
    ,glbdef7 varchar2(15) -- 申请出国（境）时间（结束）
    ,glbdef8 varchar2(15) -- 申请出国（境）时间（总）（作废）
    ,glbdef9 varchar2(750) -- 备注
    ,glbdef10 varchar2(192) -- 申请出国（境）时间（总）
    ,glbdef11 varchar2(192) -- 登记类型
    ,glbdef12 varchar2(192) -- 证件类型
    ,glbdef13 varchar2(192) -- 证件号码
    ,glbdef14 varchar2(29) -- 证件领用日期
    ,glbdef15 varchar2(29) -- 证件预计归还日期
    ,glbdef16 varchar2(15) -- 证件实际归还日期
    ,glbdef17 varchar2(29) -- 最近证件入库日期
    ,glbdef18 varchar2(2) -- 证件是否在有效期内
    ,glbdef19 varchar2(192) -- 在库状态
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
grant select on ${iol_schema}.nhrs_hi_psndoc_abroad to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_abroad to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_abroad to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_abroad to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_abroad is '出国境情况';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadarea is '所去国家(地区)';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroaddate is '出国(出境)时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadex is '异常情况';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadgroup is '团组名称';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadnumber is '审批文号';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadout is '派出单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadoutlay is '经费来源';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadpro is '审批单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadprodate is '审批时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadreturn is '回国时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadunit is '所去单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.abroadway is '出国(出境)目的';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.begindate is '起始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.enddate is '终止日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.pk_org is '所属组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef1 is '合计天数';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef2 is '出国（境）事由';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef3 is '是否出具在职证明';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef4 is '联系电话';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef5 is '户籍地';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef6 is '申请出国（境）时间（开始）';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef7 is '申请出国（境）时间（结束）';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef8 is '申请出国（境）时间（总）（作废）';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef9 is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef10 is '申请出国（境）时间（总）';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef11 is '登记类型';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef12 is '证件类型';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef13 is '证件号码';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef14 is '证件领用日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef15 is '证件预计归还日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef16 is '证件实际归还日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef17 is '最近证件入库日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef18 is '证件是否在有效期内';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.glbdef19 is '在库状态';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_abroad.etl_timestamp is 'ETL处理时间戳';

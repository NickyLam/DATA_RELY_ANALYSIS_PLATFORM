/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_ctrt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_ctrt
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_ctrt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_ctrt(
    assgid number(38,0) -- 人员任职id
    ,begindate varchar2(15) -- 合同开始日期
    ,breachmoney number(28,8) -- 赔偿金
    ,cont_unit number(38,0) -- 合同期限单位
    ,contid number(38,0) -- 合同id
    ,continuetime number(38,0) -- 连续次数
    ,contmodel varchar2(4000) -- 合同模板
    ,contractcode varchar2(63) -- 解除劳动合同证明编号
    ,contractnum varchar2(63) -- 合同编号
    ,conttype number(38,0) -- 业务类型
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,enddate varchar2(15) -- 合同结束日期
    ,filepath varchar2(750) -- 上传文件路径
    ,ifprop varchar2(2) -- 需要试用
    ,ifwrite varchar2(2) -- 是否合同模块填写
    ,isrefer varchar2(2) -- 是否提交
    ,judgedate varchar2(15) -- 鉴证日期
    ,lastflag varchar2(2) -- 是否最近记录
    ,memo varchar2(2250) -- 备注
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,neconomy number(28,8) -- 经济补偿金
    ,pk_conttext varchar2(30) -- 劳动合同模板
    ,pk_group varchar2(30) -- 所属集团
    ,pk_majorcorp varchar2(30) -- 合同主体单位
    ,pk_org varchar2(30) -- 业务发生组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 合同主键
    ,pk_psnjob varchar2(30) -- 任职主键
    ,pk_psnorg varchar2(30) -- 组织关系主键
    ,pk_termtype varchar2(30) -- 备用pk_termtype
    ,pk_unchreason varchar2(30) -- 解除合同原因
    ,presenter number(38,0) -- 解除提出方
    ,probegindate varchar2(15) -- 试用开始日期
    ,probenddate varchar2(15) -- 试用结束日期
    ,probsalary number(28,8) -- 试用期工资
    ,promonth number(38,0) -- 试用期限
    ,prop_unit number(38,0) -- 试用期限单位
    ,recordnum number(38,0) -- 记录序号
    ,signaddr varchar2(192) -- 签订地点
    ,signdate varchar2(15) -- 业务发生日期
    ,startsalary number(28,8) -- 试用期满工资
    ,termmonth number(38,0) -- 合同期限
    ,termtype varchar2(45) -- 合同期限类型
    ,ts varchar2(29) -- 时间戳
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
grant select on ${iol_schema}.nhrs_hi_psndoc_ctrt to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_ctrt to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_ctrt to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_ctrt to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_ctrt is '合同信息';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.assgid is '人员任职id';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.begindate is '合同开始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.breachmoney is '赔偿金';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.cont_unit is '合同期限单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.contid is '合同id';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.continuetime is '连续次数';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.contmodel is '合同模板';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.contractcode is '解除劳动合同证明编号';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.contractnum is '合同编号';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.conttype is '业务类型';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.enddate is '合同结束日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.filepath is '上传文件路径';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.ifprop is '需要试用';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.ifwrite is '是否合同模块填写';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.isrefer is '是否提交';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.judgedate is '鉴证日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.lastflag is '是否最近记录';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.memo is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.neconomy is '经济补偿金';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_conttext is '劳动合同模板';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_majorcorp is '合同主体单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_org is '业务发生组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_psndoc_sub is '合同主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_psnjob is '任职主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_psnorg is '组织关系主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_termtype is '备用pk_termtype';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.pk_unchreason is '解除合同原因';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.presenter is '解除提出方';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.probegindate is '试用开始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.probenddate is '试用结束日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.probsalary is '试用期工资';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.promonth is '试用期限';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.prop_unit is '试用期限单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.signaddr is '签订地点';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.signdate is '业务发生日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.startsalary is '试用期满工资';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.termmonth is '合同期限';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.termtype is '合同期限类型';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_ctrt.etl_timestamp is 'ETL处理时间戳';

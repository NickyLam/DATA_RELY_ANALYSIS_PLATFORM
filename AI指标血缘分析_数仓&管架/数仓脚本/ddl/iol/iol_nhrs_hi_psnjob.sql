/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psnjob
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psnjob
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psnjob purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psnjob(
    assgid number(38,0) -- 人员任职id
    ,begindate varchar2(15) -- 开始日期
    ,clerkcode varchar2(75) -- 员工号
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dataoriginflag number(38,0) -- 分布式
    ,deposemode varchar2(30) -- 免职方式
    ,dr number(10,0) -- 备用dr
    ,enddate varchar2(15) -- 结束日期
    ,endflag varchar2(2) -- 是否结束
    ,ismainjob varchar2(2) -- 是否主职
    ,jobmode varchar2(30) -- 任职方式
    ,lastflag varchar2(2) -- 最新记录
    ,memo varchar2(2304) -- 备注
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,occupation varchar2(30) -- 职业
    ,oribillpk varchar2(30) -- 来源单据主键
    ,oribilltype varchar2(30) -- 来源单据类型
    ,pk_dept varchar2(30) -- 部门
    ,pk_dept_v varchar2(30) -- 部门版本信息
    ,pk_group varchar2(30) -- 集团
    ,pk_hrgroup varchar2(30) -- 所属集团
    ,pk_hrorg varchar2(30) -- 人力资源组织
    ,pk_job varchar2(30) -- 职务
    ,pk_job_type varchar2(30) -- 任职类型
    ,pk_jobgrade varchar2(30) -- 职级
    ,pk_jobrank varchar2(30) -- 职等
    ,pk_org varchar2(30) -- 组织
    ,pk_org_v varchar2(30) -- 组织版本信息
    ,pk_post varchar2(30) -- 岗位
    ,pk_postseries varchar2(30) -- 岗位序列
    ,pk_psncl varchar2(30) -- 人员类别
    ,pk_psndoc varchar2(30) -- 人员
    ,pk_psnjob varchar2(30) -- 工作记录
    ,pk_psnorg varchar2(30) -- 组织关系主键
    ,poststat varchar2(2) -- 是否在岗
    ,psntype number(38,0) -- 人员类型
    ,recordnum number(38,0) -- 记录序号
    ,series varchar2(30) -- 职务类别
    ,showorder number(38,0) -- 人员顺序号
    ,trial_flag varchar2(2) -- 是否试用
    ,trial_type number(38,0) -- 试用类型
    ,trnsevent number(38,0) -- 异动事件
    ,trnsreason varchar2(30) -- 异动原因
    ,trnstype varchar2(30) -- 异动类型
    ,ts varchar2(29) -- 时间戳
    ,worktype varchar2(30) -- 工种
    ,jobglbdef1 varchar2(192) -- 办公地点及楼层
    ,jobglbdef2 varchar2(30) -- 员工层级
    ,jobglbdef3 varchar2(30) -- 是否本部办公
    ,jobglbdef4 varchar2(30) -- 是否为市场人员
    ,jobglbdef5 varchar2(30) -- 是否为管理人员
    ,jobglbdef6 varchar2(30) -- 是否清交完成
    ,jobglbdef9 varchar2(192) -- 费用核算部门
    ,jobglbdef7 varchar2(30) -- 兼职费用核算部门
    ,jobglbdef8 varchar2(192) -- 兼职费用核算部门
    ,jobglbdef10 varchar2(30) -- 职务大类
    ,jobglbdef11 varchar2(15) -- 清缴完成日期
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
grant select on ${iol_schema}.nhrs_hi_psnjob to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psnjob to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psnjob to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psnjob to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psnjob is '工作信息';
comment on column ${iol_schema}.nhrs_hi_psnjob.assgid is '人员任职id';
comment on column ${iol_schema}.nhrs_hi_psnjob.begindate is '开始日期';
comment on column ${iol_schema}.nhrs_hi_psnjob.clerkcode is '员工号';
comment on column ${iol_schema}.nhrs_hi_psnjob.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psnjob.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psnjob.dataoriginflag is '分布式';
comment on column ${iol_schema}.nhrs_hi_psnjob.deposemode is '免职方式';
comment on column ${iol_schema}.nhrs_hi_psnjob.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psnjob.enddate is '结束日期';
comment on column ${iol_schema}.nhrs_hi_psnjob.endflag is '是否结束';
comment on column ${iol_schema}.nhrs_hi_psnjob.ismainjob is '是否主职';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobmode is '任职方式';
comment on column ${iol_schema}.nhrs_hi_psnjob.lastflag is '最新记录';
comment on column ${iol_schema}.nhrs_hi_psnjob.memo is '备注';
comment on column ${iol_schema}.nhrs_hi_psnjob.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psnjob.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psnjob.occupation is '职业';
comment on column ${iol_schema}.nhrs_hi_psnjob.oribillpk is '来源单据主键';
comment on column ${iol_schema}.nhrs_hi_psnjob.oribilltype is '来源单据类型';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_dept is '部门';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_dept_v is '部门版本信息';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_group is '集团';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_hrgroup is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_hrorg is '人力资源组织';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_job is '职务';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_job_type is '任职类型';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_jobgrade is '职级';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_jobrank is '职等';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_org is '组织';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_org_v is '组织版本信息';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_post is '岗位';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_postseries is '岗位序列';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_psncl is '人员类别';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_psndoc is '人员';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_psnjob is '工作记录';
comment on column ${iol_schema}.nhrs_hi_psnjob.pk_psnorg is '组织关系主键';
comment on column ${iol_schema}.nhrs_hi_psnjob.poststat is '是否在岗';
comment on column ${iol_schema}.nhrs_hi_psnjob.psntype is '人员类型';
comment on column ${iol_schema}.nhrs_hi_psnjob.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psnjob.series is '职务类别';
comment on column ${iol_schema}.nhrs_hi_psnjob.showorder is '人员顺序号';
comment on column ${iol_schema}.nhrs_hi_psnjob.trial_flag is '是否试用';
comment on column ${iol_schema}.nhrs_hi_psnjob.trial_type is '试用类型';
comment on column ${iol_schema}.nhrs_hi_psnjob.trnsevent is '异动事件';
comment on column ${iol_schema}.nhrs_hi_psnjob.trnsreason is '异动原因';
comment on column ${iol_schema}.nhrs_hi_psnjob.trnstype is '异动类型';
comment on column ${iol_schema}.nhrs_hi_psnjob.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psnjob.worktype is '工种';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef1 is '办公地点及楼层';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef2 is '员工层级';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef3 is '是否本部办公';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef4 is '是否为市场人员';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef5 is '是否为管理人员';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef6 is '是否清交完成';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef9 is '费用核算部门';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef7 is '兼职费用核算部门';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef8 is '兼职费用核算部门';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef10 is '职务大类';
comment on column ${iol_schema}.nhrs_hi_psnjob.jobglbdef11 is '清缴完成日期';
comment on column ${iol_schema}.nhrs_hi_psnjob.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psnjob.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psnjob.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psnjob.etl_timestamp is 'ETL处理时间戳';

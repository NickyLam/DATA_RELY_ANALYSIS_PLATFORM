/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orms_t21_kri_kriinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orms_t21_kri_kriinfo
whenever sqlerror continue none;
drop table ${iol_schema}.orms_t21_kri_kriinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_kri_kriinfo(
    kriid varchar2(48) -- 指标id
    ,hisfromtype varchar2(2) -- 指标来源：0 新建，1 调整,，2 指标池复制，3承接
    ,kricode varchar2(96) -- 指标编号
    ,kriname varchar2(96) -- 指标名称
    ,krifunctype varchar2(2) -- 0：风险指标 1：控制指标 2：暴露指标
    ,kritimetype varchar2(2) -- 类型2；0：预测性 1：滞后性
    ,krilevel varchar2(2) -- 类型3 ；0：企业级，1：条线 级
    ,ifcollectkri varchar2(2) -- 是否汇总指标
    ,kridataunit varchar2(48) -- 指标指标单位（关联码表）
    ,unittype varchar2(48) -- 指标数据单位类型(与系统码表进行关联)
    ,krifreq varchar2(48) -- 指标更新频率(统一取系统定义的频率信息)
    ,kritypedesc varchar2(3000) -- 主要管控思路
    ,kridesc varchar2(3000) -- 指标描述
    ,krirespunitid varchar2(48) -- 指标归属部门
    ,krirespunitname varchar2(150) -- 指标归属部门名称
    ,krimngunitid varchar2(48) -- 负责指标的监测
    ,kricalendarid varchar2(48) -- 指标频率id
    ,expression varchar2(1500) -- 指标计算公式
    ,kricategory varchar2(2) -- 指标类别 0:员工、1:流程、2:系统、3:外部事件
    ,busgroupid varchar2(48) -- 业务条线id
    ,busgroupcode varchar2(96) -- 业务条线编码
    ,busgroupname varchar2(96) -- 业务条线名称
    ,expressiondesc varchar2(3000) -- 指标计算公式描述说明
    ,kristatus varchar2(2) -- 指标状态：0:启用 1:停用
    ,kriversion varchar2(75) -- kri的版本号
    ,krivarsiondate varchar2(15) -- 记录该版本的时间
    ,hisfromkriid varchar2(48) -- 指标历史来源id，即当前启用指标id
    ,notifimode varchar2(3) -- 通知方式：0：短信，1：邮件，2：邮件+短信
    ,recordversion number(22) -- 记录版本号
    ,createdeptid varchar2(48) -- 负责指标的建立
    ,createdeptname varchar2(150) -- 创建部门名称
    ,createdorgid varchar2(48) -- 指标所属分行编号
    ,createdorgname varchar2(150) -- 创建机构名称
    ,creatorid varchar2(48) -- 创建人id
    ,createdtime varchar2(29) -- 创建时间
    ,lastmodifierid varchar2(48) -- 最近修改人id
    ,lastmodifiedtime varchar2(29) -- 最近修改时间
    ,deleteflag varchar2(2) -- 
    ,flowstat varchar2(3) -- 状态
    ,reserve1 varchar2(3000) -- 预留字段1
    ,reserve2 varchar2(300) -- 预留字段2
    ,reserve3 varchar2(300) -- 预留字段3
    ,reserve4 varchar2(300) -- 预留字段4
    ,reserve5 varchar2(300) -- 预留字段5
    ,reserve6 varchar2(300) -- 预留字段6
    ,reserve7 varchar2(300) -- 预留字段7
    ,reserve8 varchar2(300) -- 预留字段8
    ,reserve9 varchar2(300) -- 预留字段9
    ,reserve10 varchar2(300) -- 预留字段10
    ,eventtype varchar2(48) -- 风险事件类型
    ,eventtype_disp varchar2(150) -- 风险事件类型名称
    ,reasonid varchar2(48) -- 风险损失类型
    ,reasonid_disp varchar2(150) -- 风险损失类型名称
    ,baselid varchar2(48) -- 巴塞尔业务条线
    ,baselid_disp varchar2(150) -- 巴塞尔业务条线名称
    ,eventid varchar2(48) -- 流程风险风险信息id
    ,eventid_disp varchar2(1500) -- 流程风险风险信息
    ,manageuser varchar2(192) -- 指标管理人员名称
    ,monitoruser varchar2(192) -- 指标监控人员名称
    ,manageuserid varchar2(192) -- 指标管理人员id
    ,monitoruserid varchar2(192) -- 指标监控人员id
    ,procid varchar2(48) -- 流程id
    ,procname varchar2(192) -- 流程名称
    ,mainproccode varchar2(48) -- 流程编号
    ,krilevelinfo varchar2(2) -- 是否全行
    ,krimode varchar2(2) -- 指标阀值模式 1：模式一 2：模式二 3：模式三
    ,kribelongheadid varchar2(54) -- 归属总行条线部门id
    ,kribelongheadname varchar2(192) -- 归属总行条线部门名称
    ,datesise varchar2(2) -- 数据口径
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
grant select on ${iol_schema}.orms_t21_kri_kriinfo to ${iml_schema};
grant select on ${iol_schema}.orms_t21_kri_kriinfo to ${icl_schema};
grant select on ${iol_schema}.orms_t21_kri_kriinfo to ${idl_schema};
grant select on ${iol_schema}.orms_t21_kri_kriinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.orms_t21_kri_kriinfo is '指标库表，包括：银行层级和流程层级的指标';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kriid is '指标id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.hisfromtype is '指标来源：0 新建，1 调整,，2 指标池复制，3承接';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kricode is '指标编号';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kriname is '指标名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krifunctype is '0：风险指标 1：控制指标 2：暴露指标';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kritimetype is '类型2；0：预测性 1：滞后性';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krilevel is '类型3 ；0：企业级，1：条线 级';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.ifcollectkri is '是否汇总指标';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kridataunit is '指标指标单位（关联码表）';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.unittype is '指标数据单位类型(与系统码表进行关联)';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krifreq is '指标更新频率(统一取系统定义的频率信息)';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kritypedesc is '主要管控思路';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kridesc is '指标描述';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krirespunitid is '指标归属部门';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krirespunitname is '指标归属部门名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krimngunitid is '负责指标的监测';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kricalendarid is '指标频率id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.expression is '指标计算公式';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kricategory is '指标类别 0:员工、1:流程、2:系统、3:外部事件';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.busgroupid is '业务条线id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.busgroupcode is '业务条线编码';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.busgroupname is '业务条线名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.expressiondesc is '指标计算公式描述说明';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kristatus is '指标状态：0:启用 1:停用';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kriversion is 'kri的版本号';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krivarsiondate is '记录该版本的时间';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.hisfromkriid is '指标历史来源id，即当前启用指标id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.notifimode is '通知方式：0：短信，1：邮件，2：邮件+短信';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.recordversion is '记录版本号';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.createdeptid is '负责指标的建立';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.createdeptname is '创建部门名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.createdorgid is '指标所属分行编号';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.createdorgname is '创建机构名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.creatorid is '创建人id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.createdtime is '创建时间';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.lastmodifierid is '最近修改人id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.lastmodifiedtime is '最近修改时间';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.deleteflag is '';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.flowstat is '状态';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve1 is '预留字段1';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve2 is '预留字段2';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve3 is '预留字段3';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve4 is '预留字段4';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve5 is '预留字段5';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve6 is '预留字段6';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve7 is '预留字段7';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve8 is '预留字段8';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve9 is '预留字段9';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reserve10 is '预留字段10';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.eventtype is '风险事件类型';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.eventtype_disp is '风险事件类型名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reasonid is '风险损失类型';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.reasonid_disp is '风险损失类型名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.baselid is '巴塞尔业务条线';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.baselid_disp is '巴塞尔业务条线名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.eventid is '流程风险风险信息id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.eventid_disp is '流程风险风险信息';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.manageuser is '指标管理人员名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.monitoruser is '指标监控人员名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.manageuserid is '指标管理人员id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.monitoruserid is '指标监控人员id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.procid is '流程id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.procname is '流程名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.mainproccode is '流程编号';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krilevelinfo is '是否全行';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.krimode is '指标阀值模式 1：模式一 2：模式二 3：模式三';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kribelongheadid is '归属总行条线部门id';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.kribelongheadname is '归属总行条线部门名称';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.datesise is '数据口径';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.start_dt is '开始时间';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.end_dt is '结束时间';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.id_mark is '增删标志';
comment on column ${iol_schema}.orms_t21_kri_kriinfo.etl_timestamp is 'ETL处理时间戳';

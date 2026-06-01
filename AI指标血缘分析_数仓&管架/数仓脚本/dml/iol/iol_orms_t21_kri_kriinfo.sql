/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orms_t21_kri_kriinfo
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.orms_t21_kri_kriinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orms_t21_kri_kriinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_kri_kriinfo_op purge;
drop table ${iol_schema}.orms_t21_kri_kriinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_kri_kriinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_kri_kriinfo where 0=1;

create table ${iol_schema}.orms_t21_kri_kriinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_kri_kriinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_kri_kriinfo_cl(
            kriid -- 指标ID
            ,hisfromtype -- 指标来源：0 新建，1 调整,，2 指标池复制，3承接
            ,kricode -- 指标编号
            ,kriname -- 指标名称
            ,krifunctype -- 0：风险指标 1：控制指标 2：暴露指标
            ,kritimetype -- 类型2；0：预测性 1：滞后性
            ,krilevel -- 类型3 ；0：企业级，1：条线 级
            ,ifcollectkri -- 是否汇总指标
            ,kridataunit -- 指标指标单位（关联码表）
            ,unittype -- 指标数据单位类型(与系统码表进行关联)
            ,krifreq -- 指标更新频率(统一取系统定义的频率信息)
            ,kritypedesc -- 主要管控思路
            ,kridesc -- 指标描述
            ,krirespunitid -- 指标归属部门
            ,krirespunitname -- 指标归属部门名称
            ,krimngunitid -- 负责指标的监测
            ,kricalendarid -- 指标频率ID
            ,expression -- 指标计算公式
            ,kricategory -- 指标类别 0:员工、1:流程、2:系统、3:外部事件
            ,busgroupid -- 业务条线ID
            ,busgroupcode -- 业务条线编码
            ,busgroupname -- 业务条线名称
            ,expressiondesc -- 指标计算公式描述说明
            ,kristatus -- 指标状态：0:启用 1:停用
            ,kriversion -- KRI的版本号
            ,krivarsiondate -- 记录该版本的时间
            ,hisfromkriid -- 指标历史来源ID，即当前启用指标ID
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,recordversion -- 记录版本号
            ,createdeptid -- 负责指标的建立
            ,createdeptname -- 创建部门名称
            ,createdorgid -- 指标所属分行编号
            ,createdorgname -- 创建机构名称
            ,creatorid -- 创建人ID
            ,createdtime -- 创建时间
            ,lastmodifierid -- 最近修改人ID
            ,lastmodifiedtime -- 最近修改时间
            ,deleteflag -- 
            ,flowstat -- 状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,reserve3 -- 预留字段3
            ,reserve4 -- 预留字段4
            ,reserve5 -- 预留字段5
            ,reserve6 -- 预留字段6
            ,reserve7 -- 预留字段7
            ,reserve8 -- 预留字段8
            ,reserve9 -- 预留字段9
            ,reserve10 -- 预留字段10
            ,eventtype -- 风险事件类型
            ,eventtype_disp -- 风险事件类型名称
            ,reasonid -- 风险损失类型
            ,reasonid_disp -- 风险损失类型名称
            ,baselid -- 巴塞尔业务条线
            ,baselid_disp -- 巴塞尔业务条线名称
            ,eventid -- 流程风险风险信息ID
            ,eventid_disp -- 流程风险风险信息
            ,manageuser -- 指标管理人员名称
            ,monitoruser -- 指标监控人员名称
            ,manageuserid -- 指标管理人员ID
            ,monitoruserid -- 指标监控人员ID
            ,procid -- 流程ID
            ,procname -- 流程名称
            ,mainproccode -- 流程编号
            ,krilevelinfo -- 是否全行
            ,krimode -- 指标阀值模式 1：模式一 2：模式二 3：模式三
            ,kribelongheadid -- 归属总行条线部门id
            ,kribelongheadname -- 归属总行条线部门名称
            ,datesise -- 数据口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_kri_kriinfo_op(
            kriid -- 指标ID
            ,hisfromtype -- 指标来源：0 新建，1 调整,，2 指标池复制，3承接
            ,kricode -- 指标编号
            ,kriname -- 指标名称
            ,krifunctype -- 0：风险指标 1：控制指标 2：暴露指标
            ,kritimetype -- 类型2；0：预测性 1：滞后性
            ,krilevel -- 类型3 ；0：企业级，1：条线 级
            ,ifcollectkri -- 是否汇总指标
            ,kridataunit -- 指标指标单位（关联码表）
            ,unittype -- 指标数据单位类型(与系统码表进行关联)
            ,krifreq -- 指标更新频率(统一取系统定义的频率信息)
            ,kritypedesc -- 主要管控思路
            ,kridesc -- 指标描述
            ,krirespunitid -- 指标归属部门
            ,krirespunitname -- 指标归属部门名称
            ,krimngunitid -- 负责指标的监测
            ,kricalendarid -- 指标频率ID
            ,expression -- 指标计算公式
            ,kricategory -- 指标类别 0:员工、1:流程、2:系统、3:外部事件
            ,busgroupid -- 业务条线ID
            ,busgroupcode -- 业务条线编码
            ,busgroupname -- 业务条线名称
            ,expressiondesc -- 指标计算公式描述说明
            ,kristatus -- 指标状态：0:启用 1:停用
            ,kriversion -- KRI的版本号
            ,krivarsiondate -- 记录该版本的时间
            ,hisfromkriid -- 指标历史来源ID，即当前启用指标ID
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,recordversion -- 记录版本号
            ,createdeptid -- 负责指标的建立
            ,createdeptname -- 创建部门名称
            ,createdorgid -- 指标所属分行编号
            ,createdorgname -- 创建机构名称
            ,creatorid -- 创建人ID
            ,createdtime -- 创建时间
            ,lastmodifierid -- 最近修改人ID
            ,lastmodifiedtime -- 最近修改时间
            ,deleteflag -- 
            ,flowstat -- 状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,reserve3 -- 预留字段3
            ,reserve4 -- 预留字段4
            ,reserve5 -- 预留字段5
            ,reserve6 -- 预留字段6
            ,reserve7 -- 预留字段7
            ,reserve8 -- 预留字段8
            ,reserve9 -- 预留字段9
            ,reserve10 -- 预留字段10
            ,eventtype -- 风险事件类型
            ,eventtype_disp -- 风险事件类型名称
            ,reasonid -- 风险损失类型
            ,reasonid_disp -- 风险损失类型名称
            ,baselid -- 巴塞尔业务条线
            ,baselid_disp -- 巴塞尔业务条线名称
            ,eventid -- 流程风险风险信息ID
            ,eventid_disp -- 流程风险风险信息
            ,manageuser -- 指标管理人员名称
            ,monitoruser -- 指标监控人员名称
            ,manageuserid -- 指标管理人员ID
            ,monitoruserid -- 指标监控人员ID
            ,procid -- 流程ID
            ,procname -- 流程名称
            ,mainproccode -- 流程编号
            ,krilevelinfo -- 是否全行
            ,krimode -- 指标阀值模式 1：模式一 2：模式二 3：模式三
            ,kribelongheadid -- 归属总行条线部门id
            ,kribelongheadname -- 归属总行条线部门名称
            ,datesise -- 数据口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.kriid, o.kriid) as kriid -- 指标ID
    ,nvl(n.hisfromtype, o.hisfromtype) as hisfromtype -- 指标来源：0 新建，1 调整,，2 指标池复制，3承接
    ,nvl(n.kricode, o.kricode) as kricode -- 指标编号
    ,nvl(n.kriname, o.kriname) as kriname -- 指标名称
    ,nvl(n.krifunctype, o.krifunctype) as krifunctype -- 0：风险指标 1：控制指标 2：暴露指标
    ,nvl(n.kritimetype, o.kritimetype) as kritimetype -- 类型2；0：预测性 1：滞后性
    ,nvl(n.krilevel, o.krilevel) as krilevel -- 类型3 ；0：企业级，1：条线 级
    ,nvl(n.ifcollectkri, o.ifcollectkri) as ifcollectkri -- 是否汇总指标
    ,nvl(n.kridataunit, o.kridataunit) as kridataunit -- 指标指标单位（关联码表）
    ,nvl(n.unittype, o.unittype) as unittype -- 指标数据单位类型(与系统码表进行关联)
    ,nvl(n.krifreq, o.krifreq) as krifreq -- 指标更新频率(统一取系统定义的频率信息)
    ,nvl(n.kritypedesc, o.kritypedesc) as kritypedesc -- 主要管控思路
    ,nvl(n.kridesc, o.kridesc) as kridesc -- 指标描述
    ,nvl(n.krirespunitid, o.krirespunitid) as krirespunitid -- 指标归属部门
    ,nvl(n.krirespunitname, o.krirespunitname) as krirespunitname -- 指标归属部门名称
    ,nvl(n.krimngunitid, o.krimngunitid) as krimngunitid -- 负责指标的监测
    ,nvl(n.kricalendarid, o.kricalendarid) as kricalendarid -- 指标频率ID
    ,nvl(n.expression, o.expression) as expression -- 指标计算公式
    ,nvl(n.kricategory, o.kricategory) as kricategory -- 指标类别 0:员工、1:流程、2:系统、3:外部事件
    ,nvl(n.busgroupid, o.busgroupid) as busgroupid -- 业务条线ID
    ,nvl(n.busgroupcode, o.busgroupcode) as busgroupcode -- 业务条线编码
    ,nvl(n.busgroupname, o.busgroupname) as busgroupname -- 业务条线名称
    ,nvl(n.expressiondesc, o.expressiondesc) as expressiondesc -- 指标计算公式描述说明
    ,nvl(n.kristatus, o.kristatus) as kristatus -- 指标状态：0:启用 1:停用
    ,nvl(n.kriversion, o.kriversion) as kriversion -- KRI的版本号
    ,nvl(n.krivarsiondate, o.krivarsiondate) as krivarsiondate -- 记录该版本的时间
    ,nvl(n.hisfromkriid, o.hisfromkriid) as hisfromkriid -- 指标历史来源ID，即当前启用指标ID
    ,nvl(n.notifimode, o.notifimode) as notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
    ,nvl(n.recordversion, o.recordversion) as recordversion -- 记录版本号
    ,nvl(n.createdeptid, o.createdeptid) as createdeptid -- 负责指标的建立
    ,nvl(n.createdeptname, o.createdeptname) as createdeptname -- 创建部门名称
    ,nvl(n.createdorgid, o.createdorgid) as createdorgid -- 指标所属分行编号
    ,nvl(n.createdorgname, o.createdorgname) as createdorgname -- 创建机构名称
    ,nvl(n.creatorid, o.creatorid) as creatorid -- 创建人ID
    ,nvl(n.createdtime, o.createdtime) as createdtime -- 创建时间
    ,nvl(n.lastmodifierid, o.lastmodifierid) as lastmodifierid -- 最近修改人ID
    ,nvl(n.lastmodifiedtime, o.lastmodifiedtime) as lastmodifiedtime -- 最近修改时间
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 
    ,nvl(n.flowstat, o.flowstat) as flowstat -- 状态
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 预留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 预留字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 预留字段3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 预留字段4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 预留字段5
    ,nvl(n.reserve6, o.reserve6) as reserve6 -- 预留字段6
    ,nvl(n.reserve7, o.reserve7) as reserve7 -- 预留字段7
    ,nvl(n.reserve8, o.reserve8) as reserve8 -- 预留字段8
    ,nvl(n.reserve9, o.reserve9) as reserve9 -- 预留字段9
    ,nvl(n.reserve10, o.reserve10) as reserve10 -- 预留字段10
    ,nvl(n.eventtype, o.eventtype) as eventtype -- 风险事件类型
    ,nvl(n.eventtype_disp, o.eventtype_disp) as eventtype_disp -- 风险事件类型名称
    ,nvl(n.reasonid, o.reasonid) as reasonid -- 风险损失类型
    ,nvl(n.reasonid_disp, o.reasonid_disp) as reasonid_disp -- 风险损失类型名称
    ,nvl(n.baselid, o.baselid) as baselid -- 巴塞尔业务条线
    ,nvl(n.baselid_disp, o.baselid_disp) as baselid_disp -- 巴塞尔业务条线名称
    ,nvl(n.eventid, o.eventid) as eventid -- 流程风险风险信息ID
    ,nvl(n.eventid_disp, o.eventid_disp) as eventid_disp -- 流程风险风险信息
    ,nvl(n.manageuser, o.manageuser) as manageuser -- 指标管理人员名称
    ,nvl(n.monitoruser, o.monitoruser) as monitoruser -- 指标监控人员名称
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 指标管理人员ID
    ,nvl(n.monitoruserid, o.monitoruserid) as monitoruserid -- 指标监控人员ID
    ,nvl(n.procid, o.procid) as procid -- 流程ID
    ,nvl(n.procname, o.procname) as procname -- 流程名称
    ,nvl(n.mainproccode, o.mainproccode) as mainproccode -- 流程编号
    ,nvl(n.krilevelinfo, o.krilevelinfo) as krilevelinfo -- 是否全行
    ,nvl(n.krimode, o.krimode) as krimode -- 指标阀值模式 1：模式一 2：模式二 3：模式三
    ,nvl(n.kribelongheadid, o.kribelongheadid) as kribelongheadid -- 归属总行条线部门id
    ,nvl(n.kribelongheadname, o.kribelongheadname) as kribelongheadname -- 归属总行条线部门名称
    ,nvl(n.datesise, o.datesise) as datesise -- 数据口径
    ,case when
            n.kriid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.kriid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.kriid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orms_t21_kri_kriinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orms_t21_kri_kriinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.kriid = n.kriid
where (
        o.kriid is null
    )
    or (
        n.kriid is null
    )
    or (
        o.hisfromtype <> n.hisfromtype
        or o.kricode <> n.kricode
        or o.kriname <> n.kriname
        or o.krifunctype <> n.krifunctype
        or o.kritimetype <> n.kritimetype
        or o.krilevel <> n.krilevel
        or o.ifcollectkri <> n.ifcollectkri
        or o.kridataunit <> n.kridataunit
        or o.unittype <> n.unittype
        or o.krifreq <> n.krifreq
        or o.kritypedesc <> n.kritypedesc
        or o.kridesc <> n.kridesc
        or o.krirespunitid <> n.krirespunitid
        or o.krirespunitname <> n.krirespunitname
        or o.krimngunitid <> n.krimngunitid
        or o.kricalendarid <> n.kricalendarid
        or o.expression <> n.expression
        or o.kricategory <> n.kricategory
        or o.busgroupid <> n.busgroupid
        or o.busgroupcode <> n.busgroupcode
        or o.busgroupname <> n.busgroupname
        or o.expressiondesc <> n.expressiondesc
        or o.kristatus <> n.kristatus
        or o.kriversion <> n.kriversion
        or o.krivarsiondate <> n.krivarsiondate
        or o.hisfromkriid <> n.hisfromkriid
        or o.notifimode <> n.notifimode
        or o.recordversion <> n.recordversion
        or o.createdeptid <> n.createdeptid
        or o.createdeptname <> n.createdeptname
        or o.createdorgid <> n.createdorgid
        or o.createdorgname <> n.createdorgname
        or o.creatorid <> n.creatorid
        or o.createdtime <> n.createdtime
        or o.lastmodifierid <> n.lastmodifierid
        or o.lastmodifiedtime <> n.lastmodifiedtime
        or o.deleteflag <> n.deleteflag
        or o.flowstat <> n.flowstat
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
        or o.reserve7 <> n.reserve7
        or o.reserve8 <> n.reserve8
        or o.reserve9 <> n.reserve9
        or o.reserve10 <> n.reserve10
        or o.eventtype <> n.eventtype
        or o.eventtype_disp <> n.eventtype_disp
        or o.reasonid <> n.reasonid
        or o.reasonid_disp <> n.reasonid_disp
        or o.baselid <> n.baselid
        or o.baselid_disp <> n.baselid_disp
        or o.eventid <> n.eventid
        or o.eventid_disp <> n.eventid_disp
        or o.manageuser <> n.manageuser
        or o.monitoruser <> n.monitoruser
        or o.manageuserid <> n.manageuserid
        or o.monitoruserid <> n.monitoruserid
        or o.procid <> n.procid
        or o.procname <> n.procname
        or o.mainproccode <> n.mainproccode
        or o.krilevelinfo <> n.krilevelinfo
        or o.krimode <> n.krimode
        or o.kribelongheadid <> n.kribelongheadid
        or o.kribelongheadname <> n.kribelongheadname
        or o.datesise <> n.datesise
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_kri_kriinfo_cl(
            kriid -- 指标ID
            ,hisfromtype -- 指标来源：0 新建，1 调整,，2 指标池复制，3承接
            ,kricode -- 指标编号
            ,kriname -- 指标名称
            ,krifunctype -- 0：风险指标 1：控制指标 2：暴露指标
            ,kritimetype -- 类型2；0：预测性 1：滞后性
            ,krilevel -- 类型3 ；0：企业级，1：条线 级
            ,ifcollectkri -- 是否汇总指标
            ,kridataunit -- 指标指标单位（关联码表）
            ,unittype -- 指标数据单位类型(与系统码表进行关联)
            ,krifreq -- 指标更新频率(统一取系统定义的频率信息)
            ,kritypedesc -- 主要管控思路
            ,kridesc -- 指标描述
            ,krirespunitid -- 指标归属部门
            ,krirespunitname -- 指标归属部门名称
            ,krimngunitid -- 负责指标的监测
            ,kricalendarid -- 指标频率ID
            ,expression -- 指标计算公式
            ,kricategory -- 指标类别 0:员工、1:流程、2:系统、3:外部事件
            ,busgroupid -- 业务条线ID
            ,busgroupcode -- 业务条线编码
            ,busgroupname -- 业务条线名称
            ,expressiondesc -- 指标计算公式描述说明
            ,kristatus -- 指标状态：0:启用 1:停用
            ,kriversion -- KRI的版本号
            ,krivarsiondate -- 记录该版本的时间
            ,hisfromkriid -- 指标历史来源ID，即当前启用指标ID
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,recordversion -- 记录版本号
            ,createdeptid -- 负责指标的建立
            ,createdeptname -- 创建部门名称
            ,createdorgid -- 指标所属分行编号
            ,createdorgname -- 创建机构名称
            ,creatorid -- 创建人ID
            ,createdtime -- 创建时间
            ,lastmodifierid -- 最近修改人ID
            ,lastmodifiedtime -- 最近修改时间
            ,deleteflag -- 
            ,flowstat -- 状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,reserve3 -- 预留字段3
            ,reserve4 -- 预留字段4
            ,reserve5 -- 预留字段5
            ,reserve6 -- 预留字段6
            ,reserve7 -- 预留字段7
            ,reserve8 -- 预留字段8
            ,reserve9 -- 预留字段9
            ,reserve10 -- 预留字段10
            ,eventtype -- 风险事件类型
            ,eventtype_disp -- 风险事件类型名称
            ,reasonid -- 风险损失类型
            ,reasonid_disp -- 风险损失类型名称
            ,baselid -- 巴塞尔业务条线
            ,baselid_disp -- 巴塞尔业务条线名称
            ,eventid -- 流程风险风险信息ID
            ,eventid_disp -- 流程风险风险信息
            ,manageuser -- 指标管理人员名称
            ,monitoruser -- 指标监控人员名称
            ,manageuserid -- 指标管理人员ID
            ,monitoruserid -- 指标监控人员ID
            ,procid -- 流程ID
            ,procname -- 流程名称
            ,mainproccode -- 流程编号
            ,krilevelinfo -- 是否全行
            ,krimode -- 指标阀值模式 1：模式一 2：模式二 3：模式三
            ,kribelongheadid -- 归属总行条线部门id
            ,kribelongheadname -- 归属总行条线部门名称
            ,datesise -- 数据口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_kri_kriinfo_op(
            kriid -- 指标ID
            ,hisfromtype -- 指标来源：0 新建，1 调整,，2 指标池复制，3承接
            ,kricode -- 指标编号
            ,kriname -- 指标名称
            ,krifunctype -- 0：风险指标 1：控制指标 2：暴露指标
            ,kritimetype -- 类型2；0：预测性 1：滞后性
            ,krilevel -- 类型3 ；0：企业级，1：条线 级
            ,ifcollectkri -- 是否汇总指标
            ,kridataunit -- 指标指标单位（关联码表）
            ,unittype -- 指标数据单位类型(与系统码表进行关联)
            ,krifreq -- 指标更新频率(统一取系统定义的频率信息)
            ,kritypedesc -- 主要管控思路
            ,kridesc -- 指标描述
            ,krirespunitid -- 指标归属部门
            ,krirespunitname -- 指标归属部门名称
            ,krimngunitid -- 负责指标的监测
            ,kricalendarid -- 指标频率ID
            ,expression -- 指标计算公式
            ,kricategory -- 指标类别 0:员工、1:流程、2:系统、3:外部事件
            ,busgroupid -- 业务条线ID
            ,busgroupcode -- 业务条线编码
            ,busgroupname -- 业务条线名称
            ,expressiondesc -- 指标计算公式描述说明
            ,kristatus -- 指标状态：0:启用 1:停用
            ,kriversion -- KRI的版本号
            ,krivarsiondate -- 记录该版本的时间
            ,hisfromkriid -- 指标历史来源ID，即当前启用指标ID
            ,notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
            ,recordversion -- 记录版本号
            ,createdeptid -- 负责指标的建立
            ,createdeptname -- 创建部门名称
            ,createdorgid -- 指标所属分行编号
            ,createdorgname -- 创建机构名称
            ,creatorid -- 创建人ID
            ,createdtime -- 创建时间
            ,lastmodifierid -- 最近修改人ID
            ,lastmodifiedtime -- 最近修改时间
            ,deleteflag -- 
            ,flowstat -- 状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,reserve3 -- 预留字段3
            ,reserve4 -- 预留字段4
            ,reserve5 -- 预留字段5
            ,reserve6 -- 预留字段6
            ,reserve7 -- 预留字段7
            ,reserve8 -- 预留字段8
            ,reserve9 -- 预留字段9
            ,reserve10 -- 预留字段10
            ,eventtype -- 风险事件类型
            ,eventtype_disp -- 风险事件类型名称
            ,reasonid -- 风险损失类型
            ,reasonid_disp -- 风险损失类型名称
            ,baselid -- 巴塞尔业务条线
            ,baselid_disp -- 巴塞尔业务条线名称
            ,eventid -- 流程风险风险信息ID
            ,eventid_disp -- 流程风险风险信息
            ,manageuser -- 指标管理人员名称
            ,monitoruser -- 指标监控人员名称
            ,manageuserid -- 指标管理人员ID
            ,monitoruserid -- 指标监控人员ID
            ,procid -- 流程ID
            ,procname -- 流程名称
            ,mainproccode -- 流程编号
            ,krilevelinfo -- 是否全行
            ,krimode -- 指标阀值模式 1：模式一 2：模式二 3：模式三
            ,kribelongheadid -- 归属总行条线部门id
            ,kribelongheadname -- 归属总行条线部门名称
            ,datesise -- 数据口径
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.kriid -- 指标ID
    ,o.hisfromtype -- 指标来源：0 新建，1 调整,，2 指标池复制，3承接
    ,o.kricode -- 指标编号
    ,o.kriname -- 指标名称
    ,o.krifunctype -- 0：风险指标 1：控制指标 2：暴露指标
    ,o.kritimetype -- 类型2；0：预测性 1：滞后性
    ,o.krilevel -- 类型3 ；0：企业级，1：条线 级
    ,o.ifcollectkri -- 是否汇总指标
    ,o.kridataunit -- 指标指标单位（关联码表）
    ,o.unittype -- 指标数据单位类型(与系统码表进行关联)
    ,o.krifreq -- 指标更新频率(统一取系统定义的频率信息)
    ,o.kritypedesc -- 主要管控思路
    ,o.kridesc -- 指标描述
    ,o.krirespunitid -- 指标归属部门
    ,o.krirespunitname -- 指标归属部门名称
    ,o.krimngunitid -- 负责指标的监测
    ,o.kricalendarid -- 指标频率ID
    ,o.expression -- 指标计算公式
    ,o.kricategory -- 指标类别 0:员工、1:流程、2:系统、3:外部事件
    ,o.busgroupid -- 业务条线ID
    ,o.busgroupcode -- 业务条线编码
    ,o.busgroupname -- 业务条线名称
    ,o.expressiondesc -- 指标计算公式描述说明
    ,o.kristatus -- 指标状态：0:启用 1:停用
    ,o.kriversion -- KRI的版本号
    ,o.krivarsiondate -- 记录该版本的时间
    ,o.hisfromkriid -- 指标历史来源ID，即当前启用指标ID
    ,o.notifimode -- 通知方式：0：短信，1：邮件，2：邮件+短信
    ,o.recordversion -- 记录版本号
    ,o.createdeptid -- 负责指标的建立
    ,o.createdeptname -- 创建部门名称
    ,o.createdorgid -- 指标所属分行编号
    ,o.createdorgname -- 创建机构名称
    ,o.creatorid -- 创建人ID
    ,o.createdtime -- 创建时间
    ,o.lastmodifierid -- 最近修改人ID
    ,o.lastmodifiedtime -- 最近修改时间
    ,o.deleteflag -- 
    ,o.flowstat -- 状态
    ,o.reserve1 -- 预留字段1
    ,o.reserve2 -- 预留字段2
    ,o.reserve3 -- 预留字段3
    ,o.reserve4 -- 预留字段4
    ,o.reserve5 -- 预留字段5
    ,o.reserve6 -- 预留字段6
    ,o.reserve7 -- 预留字段7
    ,o.reserve8 -- 预留字段8
    ,o.reserve9 -- 预留字段9
    ,o.reserve10 -- 预留字段10
    ,o.eventtype -- 风险事件类型
    ,o.eventtype_disp -- 风险事件类型名称
    ,o.reasonid -- 风险损失类型
    ,o.reasonid_disp -- 风险损失类型名称
    ,o.baselid -- 巴塞尔业务条线
    ,o.baselid_disp -- 巴塞尔业务条线名称
    ,o.eventid -- 流程风险风险信息ID
    ,o.eventid_disp -- 流程风险风险信息
    ,o.manageuser -- 指标管理人员名称
    ,o.monitoruser -- 指标监控人员名称
    ,o.manageuserid -- 指标管理人员ID
    ,o.monitoruserid -- 指标监控人员ID
    ,o.procid -- 流程ID
    ,o.procname -- 流程名称
    ,o.mainproccode -- 流程编号
    ,o.krilevelinfo -- 是否全行
    ,o.krimode -- 指标阀值模式 1：模式一 2：模式二 3：模式三
    ,o.kribelongheadid -- 归属总行条线部门id
    ,o.kribelongheadname -- 归属总行条线部门名称
    ,o.datesise -- 数据口径
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.orms_t21_kri_kriinfo_bk o
    left join ${iol_schema}.orms_t21_kri_kriinfo_op n
        on
            o.kriid = n.kriid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orms_t21_kri_kriinfo_cl d
        on
            o.kriid = d.kriid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.orms_t21_kri_kriinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.orms_t21_kri_kriinfo exchange partition p_19000101 with table ${iol_schema}.orms_t21_kri_kriinfo_cl;
alter table ${iol_schema}.orms_t21_kri_kriinfo exchange partition p_20991231 with table ${iol_schema}.orms_t21_kri_kriinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orms_t21_kri_kriinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_kri_kriinfo_op purge;
drop table ${iol_schema}.orms_t21_kri_kriinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orms_t21_kri_kriinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orms_t21_kri_kriinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);

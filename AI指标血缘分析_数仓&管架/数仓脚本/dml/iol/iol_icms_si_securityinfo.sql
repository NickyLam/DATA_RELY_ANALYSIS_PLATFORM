/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_si_securityinfo
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
create table ${iol_schema}.icms_si_securityinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_si_securityinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_si_securityinfo_op purge;
drop table ${iol_schema}.icms_si_securityinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_si_securityinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_si_securityinfo where 0=1;

create table ${iol_schema}.icms_si_securityinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_si_securityinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_si_securityinfo_cl(
            sccode -- 押品编号
            ,guartype -- 押品类型编号
            ,createuser -- 押品主管(创建人)
            ,deptcode -- 押品所属机构
            ,createdate -- 建立时间
            ,conominium -- 是否共同财产 C0101，0 否、1 是
            ,conshare -- 抵质押品权利人所占份额
            ,effecttype -- 担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它
            ,isinsure -- 是否需要办理保险 C0101，  0 否、1 是
            ,guaregisterstate -- 押品登记办理状态 1072，  01 未办理，  02 已办理
            ,guainsurestate -- 押品保险办理状态 1073，  01 有效，  02 失效
            ,state -- 押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失
            ,usestate -- 押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置
            ,guaspecialstate -- 押品状态
            ,bxability -- 权重法变现能力 BXNL， 0 低， 1 高
            ,isotherguar -- 是否他行担保 C0101，0 否、1 是
            ,isgencust -- 是否代保管 C0101，0 否、1 是
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种代码 对应字典编号0302
            ,evaldate -- 评估时间
            ,datasourceflag -- 数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植
            ,exapstate -- 押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。
            ,editstate -- 押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0
            ,bxability2 -- 初级内评法变现能力
            ,isgain -- 是否取得关键信息
            ,ismodify -- 是否可修改
            ,guarinfoname -- 押品名称
            ,controlchange -- 质押物控制力调整系数 CONTROLCHANGE
            ,updates -- 最新修改日期
            ,upduser -- 最新修改人
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物
            ,issequence -- 是否第一顺位 C0101   0 否、1 是
            ,ismulti -- 是否二押 C0101  0 否、1 是
            ,amount -- 优先受偿权数额
            ,investsignage -- 投资类标识 1 是  否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_si_securityinfo_op(
            sccode -- 押品编号
            ,guartype -- 押品类型编号
            ,createuser -- 押品主管(创建人)
            ,deptcode -- 押品所属机构
            ,createdate -- 建立时间
            ,conominium -- 是否共同财产 C0101，0 否、1 是
            ,conshare -- 抵质押品权利人所占份额
            ,effecttype -- 担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它
            ,isinsure -- 是否需要办理保险 C0101，  0 否、1 是
            ,guaregisterstate -- 押品登记办理状态 1072，  01 未办理，  02 已办理
            ,guainsurestate -- 押品保险办理状态 1073，  01 有效，  02 失效
            ,state -- 押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失
            ,usestate -- 押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置
            ,guaspecialstate -- 押品状态
            ,bxability -- 权重法变现能力 BXNL， 0 低， 1 高
            ,isotherguar -- 是否他行担保 C0101，0 否、1 是
            ,isgencust -- 是否代保管 C0101，0 否、1 是
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种代码 对应字典编号0302
            ,evaldate -- 评估时间
            ,datasourceflag -- 数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植
            ,exapstate -- 押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。
            ,editstate -- 押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0
            ,bxability2 -- 初级内评法变现能力
            ,isgain -- 是否取得关键信息
            ,ismodify -- 是否可修改
            ,guarinfoname -- 押品名称
            ,controlchange -- 质押物控制力调整系数 CONTROLCHANGE
            ,updates -- 最新修改日期
            ,upduser -- 最新修改人
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物
            ,issequence -- 是否第一顺位 C0101   0 否、1 是
            ,ismulti -- 是否二押 C0101  0 否、1 是
            ,amount -- 优先受偿权数额
            ,investsignage -- 投资类标识 1 是  否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.guartype, o.guartype) as guartype -- 押品类型编号
    ,nvl(n.createuser, o.createuser) as createuser -- 押品主管(创建人)
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 押品所属机构
    ,nvl(n.createdate, o.createdate) as createdate -- 建立时间
    ,nvl(n.conominium, o.conominium) as conominium -- 是否共同财产 C0101，0 否、1 是
    ,nvl(n.conshare, o.conshare) as conshare -- 抵质押品权利人所占份额
    ,nvl(n.effecttype, o.effecttype) as effecttype -- 担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它
    ,nvl(n.isinsure, o.isinsure) as isinsure -- 是否需要办理保险 C0101，  0 否、1 是
    ,nvl(n.guaregisterstate, o.guaregisterstate) as guaregisterstate -- 押品登记办理状态 1072，  01 未办理，  02 已办理
    ,nvl(n.guainsurestate, o.guainsurestate) as guainsurestate -- 押品保险办理状态 1073，  01 有效，  02 失效
    ,nvl(n.state, o.state) as state -- 押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失
    ,nvl(n.usestate, o.usestate) as usestate -- 押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置
    ,nvl(n.guaspecialstate, o.guaspecialstate) as guaspecialstate -- 押品状态
    ,nvl(n.bxability, o.bxability) as bxability -- 权重法变现能力 BXNL， 0 低， 1 高
    ,nvl(n.isotherguar, o.isotherguar) as isotherguar -- 是否他行担保 C0101，0 否、1 是
    ,nvl(n.isgencust, o.isgencust) as isgencust -- 是否代保管 C0101，0 否、1 是
    ,nvl(n.confmamt, o.confmamt) as confmamt -- 我行确认价值
    ,nvl(n.confmcurrency, o.confmcurrency) as confmcurrency -- 我行确认价值币种代码 对应字典编号0302
    ,nvl(n.evaldate, o.evaldate) as evaldate -- 评估时间
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植
    ,nvl(n.exapstate, o.exapstate) as exapstate -- 押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。
    ,nvl(n.editstate, o.editstate) as editstate -- 押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0
    ,nvl(n.bxability2, o.bxability2) as bxability2 -- 初级内评法变现能力
    ,nvl(n.isgain, o.isgain) as isgain -- 是否取得关键信息
    ,nvl(n.ismodify, o.ismodify) as ismodify -- 是否可修改
    ,nvl(n.guarinfoname, o.guarinfoname) as guarinfoname -- 押品名称
    ,nvl(n.controlchange, o.controlchange) as controlchange -- 质押物控制力调整系数 CONTROLCHANGE
    ,nvl(n.updates, o.updates) as updates -- 最新修改日期
    ,nvl(n.upduser, o.upduser) as upduser -- 最新修改人
    ,nvl(n.issaveowner, o.issaveowner) as issaveowner -- 是否保存我行
    ,nvl(n.guarsign, o.guarsign) as guarsign -- 抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物
    ,nvl(n.issequence, o.issequence) as issequence -- 是否第一顺位 C0101   0 否、1 是
    ,nvl(n.ismulti, o.ismulti) as ismulti -- 是否二押 C0101  0 否、1 是
    ,nvl(n.amount, o.amount) as amount -- 优先受偿权数额
    ,nvl(n.investsignage, o.investsignage) as investsignage -- 投资类标识 1 是  否
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_si_securityinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_si_securityinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.guartype <> n.guartype
        or o.createuser <> n.createuser
        or o.deptcode <> n.deptcode
        or o.createdate <> n.createdate
        or o.conominium <> n.conominium
        or o.conshare <> n.conshare
        or o.effecttype <> n.effecttype
        or o.isinsure <> n.isinsure
        or o.guaregisterstate <> n.guaregisterstate
        or o.guainsurestate <> n.guainsurestate
        or o.state <> n.state
        or o.usestate <> n.usestate
        or o.guaspecialstate <> n.guaspecialstate
        or o.bxability <> n.bxability
        or o.isotherguar <> n.isotherguar
        or o.isgencust <> n.isgencust
        or o.confmamt <> n.confmamt
        or o.confmcurrency <> n.confmcurrency
        or o.evaldate <> n.evaldate
        or o.datasourceflag <> n.datasourceflag
        or o.exapstate <> n.exapstate
        or o.editstate <> n.editstate
        or o.bxability2 <> n.bxability2
        or o.isgain <> n.isgain
        or o.ismodify <> n.ismodify
        or o.guarinfoname <> n.guarinfoname
        or o.controlchange <> n.controlchange
        or o.updates <> n.updates
        or o.upduser <> n.upduser
        or o.issaveowner <> n.issaveowner
        or o.guarsign <> n.guarsign
        or o.issequence <> n.issequence
        or o.ismulti <> n.ismulti
        or o.amount <> n.amount
        or o.investsignage <> n.investsignage
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_si_securityinfo_cl(
            sccode -- 押品编号
            ,guartype -- 押品类型编号
            ,createuser -- 押品主管(创建人)
            ,deptcode -- 押品所属机构
            ,createdate -- 建立时间
            ,conominium -- 是否共同财产 C0101，0 否、1 是
            ,conshare -- 抵质押品权利人所占份额
            ,effecttype -- 担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它
            ,isinsure -- 是否需要办理保险 C0101，  0 否、1 是
            ,guaregisterstate -- 押品登记办理状态 1072，  01 未办理，  02 已办理
            ,guainsurestate -- 押品保险办理状态 1073，  01 有效，  02 失效
            ,state -- 押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失
            ,usestate -- 押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置
            ,guaspecialstate -- 押品状态
            ,bxability -- 权重法变现能力 BXNL， 0 低， 1 高
            ,isotherguar -- 是否他行担保 C0101，0 否、1 是
            ,isgencust -- 是否代保管 C0101，0 否、1 是
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种代码 对应字典编号0302
            ,evaldate -- 评估时间
            ,datasourceflag -- 数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植
            ,exapstate -- 押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。
            ,editstate -- 押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0
            ,bxability2 -- 初级内评法变现能力
            ,isgain -- 是否取得关键信息
            ,ismodify -- 是否可修改
            ,guarinfoname -- 押品名称
            ,controlchange -- 质押物控制力调整系数 CONTROLCHANGE
            ,updates -- 最新修改日期
            ,upduser -- 最新修改人
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物
            ,issequence -- 是否第一顺位 C0101   0 否、1 是
            ,ismulti -- 是否二押 C0101  0 否、1 是
            ,amount -- 优先受偿权数额
            ,investsignage -- 投资类标识 1 是  否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_si_securityinfo_op(
            sccode -- 押品编号
            ,guartype -- 押品类型编号
            ,createuser -- 押品主管(创建人)
            ,deptcode -- 押品所属机构
            ,createdate -- 建立时间
            ,conominium -- 是否共同财产 C0101，0 否、1 是
            ,conshare -- 抵质押品权利人所占份额
            ,effecttype -- 担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它
            ,isinsure -- 是否需要办理保险 C0101，  0 否、1 是
            ,guaregisterstate -- 押品登记办理状态 1072，  01 未办理，  02 已办理
            ,guainsurestate -- 押品保险办理状态 1073，  01 有效，  02 失效
            ,state -- 押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失
            ,usestate -- 押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置
            ,guaspecialstate -- 押品状态
            ,bxability -- 权重法变现能力 BXNL， 0 低， 1 高
            ,isotherguar -- 是否他行担保 C0101，0 否、1 是
            ,isgencust -- 是否代保管 C0101，0 否、1 是
            ,confmamt -- 我行确认价值
            ,confmcurrency -- 我行确认价值币种代码 对应字典编号0302
            ,evaldate -- 评估时间
            ,datasourceflag -- 数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植
            ,exapstate -- 押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。
            ,editstate -- 押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0
            ,bxability2 -- 初级内评法变现能力
            ,isgain -- 是否取得关键信息
            ,ismodify -- 是否可修改
            ,guarinfoname -- 押品名称
            ,controlchange -- 质押物控制力调整系数 CONTROLCHANGE
            ,updates -- 最新修改日期
            ,upduser -- 最新修改人
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物
            ,issequence -- 是否第一顺位 C0101   0 否、1 是
            ,ismulti -- 是否二押 C0101  0 否、1 是
            ,amount -- 优先受偿权数额
            ,investsignage -- 投资类标识 1 是  否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.guartype -- 押品类型编号
    ,o.createuser -- 押品主管(创建人)
    ,o.deptcode -- 押品所属机构
    ,o.createdate -- 建立时间
    ,o.conominium -- 是否共同财产 C0101，0 否、1 是
    ,o.conshare -- 抵质押品权利人所占份额
    ,o.effecttype -- 担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它
    ,o.isinsure -- 是否需要办理保险 C0101，  0 否、1 是
    ,o.guaregisterstate -- 押品登记办理状态 1072，  01 未办理，  02 已办理
    ,o.guainsurestate -- 押品保险办理状态 1073，  01 有效，  02 失效
    ,o.state -- 押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失
    ,o.usestate -- 押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置
    ,o.guaspecialstate -- 押品状态
    ,o.bxability -- 权重法变现能力 BXNL， 0 低， 1 高
    ,o.isotherguar -- 是否他行担保 C0101，0 否、1 是
    ,o.isgencust -- 是否代保管 C0101，0 否、1 是
    ,o.confmamt -- 我行确认价值
    ,o.confmcurrency -- 我行确认价值币种代码 对应字典编号0302
    ,o.evaldate -- 评估时间
    ,o.datasourceflag -- 数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植
    ,o.exapstate -- 押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。
    ,o.editstate -- 押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0
    ,o.bxability2 -- 初级内评法变现能力
    ,o.isgain -- 是否取得关键信息
    ,o.ismodify -- 是否可修改
    ,o.guarinfoname -- 押品名称
    ,o.controlchange -- 质押物控制力调整系数 CONTROLCHANGE
    ,o.updates -- 最新修改日期
    ,o.upduser -- 最新修改人
    ,o.issaveowner -- 是否保存我行
    ,o.guarsign -- 抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物
    ,o.issequence -- 是否第一顺位 C0101   0 否、1 是
    ,o.ismulti -- 是否二押 C0101  0 否、1 是
    ,o.amount -- 优先受偿权数额
    ,o.investsignage -- 投资类标识 1 是  否
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_si_securityinfo_bk o
    left join ${iol_schema}.icms_si_securityinfo_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_si_securityinfo_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_si_securityinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_si_securityinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_si_securityinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_si_securityinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_si_securityinfo exchange partition p_${batch_date} with table ${iol_schema}.icms_si_securityinfo_cl;
alter table ${iol_schema}.icms_si_securityinfo exchange partition p_20991231 with table ${iol_schema}.icms_si_securityinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_si_securityinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_si_securityinfo_op purge;
drop table ${iol_schema}.icms_si_securityinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_si_securityinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_si_securityinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);

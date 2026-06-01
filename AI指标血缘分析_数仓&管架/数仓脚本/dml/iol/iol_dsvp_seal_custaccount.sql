/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_dsvp_seal_custaccount
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
create table ${iol_schema}.dsvp_seal_custaccount_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.dsvp_seal_custaccount
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dsvp_seal_custaccount_op purge;
drop table ${iol_schema}.dsvp_seal_custaccount_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dsvp_seal_custaccount_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dsvp_seal_custaccount where 0=1;

create table ${iol_schema}.dsvp_seal_custaccount_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dsvp_seal_custaccount where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dsvp_seal_custaccount_cl(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,areano -- 地区代码
            ,oldcardno -- 旧印鉴卡序号
            ,cardprintno -- 印鉴卡号
            ,branchno -- 机构编号
            ,siteno -- 建模机构编号
            ,subjectno -- 科目编号
            ,name -- 账户名称
            ,address -- 地址
            ,postcode -- 邮政编号
            ,noteex -- 备注
            ,contactman -- 联系人
            ,contactphone -- 联系电话
            ,email -- 邮箱
            ,personalid -- 身份证编号
            ,quality -- 通兑标识（1-通存通兑，2-非通存通兑）
            ,type -- 预留字段0
            ,monittype -- 监控标识（0-正常，1-监控户，2-关注户）
            ,opendate -- 开户日期
            ,destroydate -- 销户日期
            ,operator -- 员工编号
            ,checker -- 员工编号
            ,sealcount -- 印章数量
            ,siteid -- 节点号
            ,createdate -- 建模日期
            ,usedate -- 启用日期
            ,stopdate -- 停用日期
            ,drawoutdate -- 抽卡日期
            ,state -- 印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）
            ,checkflag -- 复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）
            ,destroyflag -- 销户标识（0-正常，1-销户）
            ,loseflag -- 挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）
            ,acctproperty -- 账户性质
            ,billtype -- 币种编号
            ,flagfield -- 标识域
            ,suspectnote -- 监控备注
            ,mainaccno -- 主账号
            ,reservedchar1 -- 预留字段1
            ,reservedchar2 -- 退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）
            ,reservedchar3 -- 退回理由
            ,reservedchar4 -- 预留字段4
            ,belongflag -- 共用标识（0-非共用，1-主账户，2-从账户）
            ,password -- 密码
            ,workdate -- 工作日期
            ,systemdate -- 系统日期
            ,verifycombination -- 验印组合
            ,datamac -- 数据MAC
            ,imgmac -- 图像MAC
            ,imglen -- 图像大小
            ,sealimages -- 印章信息
            ,standbyamount -- 保证金金额
            ,accountstate -- 账户状态
            ,prescanimageid -- 图像编号
            ,prescanflag -- 采集标识（0-否，1-是）
            ,printcount -- 打印次数
            ,modifyflag -- 修改标识（0-未校验，1-已校验）
            ,custno -- 核心客户号
            ,custname -- 客户名称
            ,other1 -- 预留字段3
            ,other2 -- 预留字段4
            ,other3 -- 预留字段5
            ,checkbranchno -- 复核机构编号
            ,collectbranchno -- 采集机构编号
            ,precollectflag -- 预采集标识
            ,acctype -- 账户类型
            ,qualitybranch -- 指定机构通兑
            ,freezedate -- 挂失日志————--借用冻结日期
            ,freezeflag -- 
            ,open_user -- 账户的开户柜员号
            ,rebuild_combo -- 重建验印组合标志（"0"-非重建组合 "1"-重建组合）
            ,card_status -- 最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dsvp_seal_custaccount_op(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,areano -- 地区代码
            ,oldcardno -- 旧印鉴卡序号
            ,cardprintno -- 印鉴卡号
            ,branchno -- 机构编号
            ,siteno -- 建模机构编号
            ,subjectno -- 科目编号
            ,name -- 账户名称
            ,address -- 地址
            ,postcode -- 邮政编号
            ,noteex -- 备注
            ,contactman -- 联系人
            ,contactphone -- 联系电话
            ,email -- 邮箱
            ,personalid -- 身份证编号
            ,quality -- 通兑标识（1-通存通兑，2-非通存通兑）
            ,type -- 预留字段0
            ,monittype -- 监控标识（0-正常，1-监控户，2-关注户）
            ,opendate -- 开户日期
            ,destroydate -- 销户日期
            ,operator -- 员工编号
            ,checker -- 员工编号
            ,sealcount -- 印章数量
            ,siteid -- 节点号
            ,createdate -- 建模日期
            ,usedate -- 启用日期
            ,stopdate -- 停用日期
            ,drawoutdate -- 抽卡日期
            ,state -- 印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）
            ,checkflag -- 复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）
            ,destroyflag -- 销户标识（0-正常，1-销户）
            ,loseflag -- 挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）
            ,acctproperty -- 账户性质
            ,billtype -- 币种编号
            ,flagfield -- 标识域
            ,suspectnote -- 监控备注
            ,mainaccno -- 主账号
            ,reservedchar1 -- 预留字段1
            ,reservedchar2 -- 退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）
            ,reservedchar3 -- 退回理由
            ,reservedchar4 -- 预留字段4
            ,belongflag -- 共用标识（0-非共用，1-主账户，2-从账户）
            ,password -- 密码
            ,workdate -- 工作日期
            ,systemdate -- 系统日期
            ,verifycombination -- 验印组合
            ,datamac -- 数据MAC
            ,imgmac -- 图像MAC
            ,imglen -- 图像大小
            ,sealimages -- 印章信息
            ,standbyamount -- 保证金金额
            ,accountstate -- 账户状态
            ,prescanimageid -- 图像编号
            ,prescanflag -- 采集标识（0-否，1-是）
            ,printcount -- 打印次数
            ,modifyflag -- 修改标识（0-未校验，1-已校验）
            ,custno -- 核心客户号
            ,custname -- 客户名称
            ,other1 -- 预留字段3
            ,other2 -- 预留字段4
            ,other3 -- 预留字段5
            ,checkbranchno -- 复核机构编号
            ,collectbranchno -- 采集机构编号
            ,precollectflag -- 预采集标识
            ,acctype -- 账户类型
            ,qualitybranch -- 指定机构通兑
            ,freezedate -- 挂失日志————--借用冻结日期
            ,freezeflag -- 
            ,open_user -- 账户的开户柜员号
            ,rebuild_combo -- 重建验印组合标志（"0"-非重建组合 "1"-重建组合）
            ,card_status -- 最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dbserno, o.dbserno) as dbserno -- 编号
    ,nvl(n.accountno, o.accountno) as accountno -- 账号
    ,nvl(n.sealcardno, o.sealcardno) as sealcardno -- 印鉴卡序号
    ,nvl(n.areano, o.areano) as areano -- 地区代码
    ,nvl(n.oldcardno, o.oldcardno) as oldcardno -- 旧印鉴卡序号
    ,nvl(n.cardprintno, o.cardprintno) as cardprintno -- 印鉴卡号
    ,nvl(n.branchno, o.branchno) as branchno -- 机构编号
    ,nvl(n.siteno, o.siteno) as siteno -- 建模机构编号
    ,nvl(n.subjectno, o.subjectno) as subjectno -- 科目编号
    ,nvl(n.name, o.name) as name -- 账户名称
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.postcode, o.postcode) as postcode -- 邮政编号
    ,nvl(n.noteex, o.noteex) as noteex -- 备注
    ,nvl(n.contactman, o.contactman) as contactman -- 联系人
    ,nvl(n.contactphone, o.contactphone) as contactphone -- 联系电话
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.personalid, o.personalid) as personalid -- 身份证编号
    ,nvl(n.quality, o.quality) as quality -- 通兑标识（1-通存通兑，2-非通存通兑）
    ,nvl(n.type, o.type) as type -- 预留字段0
    ,nvl(n.monittype, o.monittype) as monittype -- 监控标识（0-正常，1-监控户，2-关注户）
    ,nvl(n.opendate, o.opendate) as opendate -- 开户日期
    ,nvl(n.destroydate, o.destroydate) as destroydate -- 销户日期
    ,nvl(n.operator, o.operator) as operator -- 员工编号
    ,nvl(n.checker, o.checker) as checker -- 员工编号
    ,nvl(n.sealcount, o.sealcount) as sealcount -- 印章数量
    ,nvl(n.siteid, o.siteid) as siteid -- 节点号
    ,nvl(n.createdate, o.createdate) as createdate -- 建模日期
    ,nvl(n.usedate, o.usedate) as usedate -- 启用日期
    ,nvl(n.stopdate, o.stopdate) as stopdate -- 停用日期
    ,nvl(n.drawoutdate, o.drawoutdate) as drawoutdate -- 抽卡日期
    ,nvl(n.state, o.state) as state -- 印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）
    ,nvl(n.checkflag, o.checkflag) as checkflag -- 复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）
    ,nvl(n.destroyflag, o.destroyflag) as destroyflag -- 销户标识（0-正常，1-销户）
    ,nvl(n.loseflag, o.loseflag) as loseflag -- 挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）
    ,nvl(n.acctproperty, o.acctproperty) as acctproperty -- 账户性质
    ,nvl(n.billtype, o.billtype) as billtype -- 币种编号
    ,nvl(n.flagfield, o.flagfield) as flagfield -- 标识域
    ,nvl(n.suspectnote, o.suspectnote) as suspectnote -- 监控备注
    ,nvl(n.mainaccno, o.mainaccno) as mainaccno -- 主账号
    ,nvl(n.reservedchar1, o.reservedchar1) as reservedchar1 -- 预留字段1
    ,nvl(n.reservedchar2, o.reservedchar2) as reservedchar2 -- 退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）
    ,nvl(n.reservedchar3, o.reservedchar3) as reservedchar3 -- 退回理由
    ,nvl(n.reservedchar4, o.reservedchar4) as reservedchar4 -- 预留字段4
    ,nvl(n.belongflag, o.belongflag) as belongflag -- 共用标识（0-非共用，1-主账户，2-从账户）
    ,nvl(n.password, o.password) as password -- 密码
    ,nvl(n.workdate, o.workdate) as workdate -- 工作日期
    ,nvl(n.systemdate, o.systemdate) as systemdate -- 系统日期
    ,nvl(n.verifycombination, o.verifycombination) as verifycombination -- 验印组合
    ,nvl(n.datamac, o.datamac) as datamac -- 数据MAC
    ,nvl(n.imgmac, o.imgmac) as imgmac -- 图像MAC
    ,nvl(n.imglen, o.imglen) as imglen -- 图像大小
    ,nvl(n.sealimages, o.sealimages) as sealimages -- 印章信息
    ,nvl(n.standbyamount, o.standbyamount) as standbyamount -- 保证金金额
    ,nvl(n.accountstate, o.accountstate) as accountstate -- 账户状态
    ,nvl(n.prescanimageid, o.prescanimageid) as prescanimageid -- 图像编号
    ,nvl(n.prescanflag, o.prescanflag) as prescanflag -- 采集标识（0-否，1-是）
    ,nvl(n.printcount, o.printcount) as printcount -- 打印次数
    ,nvl(n.modifyflag, o.modifyflag) as modifyflag -- 修改标识（0-未校验，1-已校验）
    ,nvl(n.custno, o.custno) as custno -- 核心客户号
    ,nvl(n.custname, o.custname) as custname -- 客户名称
    ,nvl(n.other1, o.other1) as other1 -- 预留字段3
    ,nvl(n.other2, o.other2) as other2 -- 预留字段4
    ,nvl(n.other3, o.other3) as other3 -- 预留字段5
    ,nvl(n.checkbranchno, o.checkbranchno) as checkbranchno -- 复核机构编号
    ,nvl(n.collectbranchno, o.collectbranchno) as collectbranchno -- 采集机构编号
    ,nvl(n.precollectflag, o.precollectflag) as precollectflag -- 预采集标识
    ,nvl(n.acctype, o.acctype) as acctype -- 账户类型
    ,nvl(n.qualitybranch, o.qualitybranch) as qualitybranch -- 指定机构通兑
    ,nvl(n.freezedate, o.freezedate) as freezedate -- 挂失日志————--借用冻结日期
    ,nvl(n.freezeflag, o.freezeflag) as freezeflag -- 
    ,nvl(n.open_user, o.open_user) as open_user -- 账户的开户柜员号
    ,nvl(n.rebuild_combo, o.rebuild_combo) as rebuild_combo -- 重建验印组合标志（"0"-非重建组合 "1"-重建组合）
    ,nvl(n.card_status, o.card_status) as card_status -- 最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)
    ,case when
            n.dbserno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dbserno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dbserno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.dsvp_seal_custaccount_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.dsvp_seal_custaccount where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dbserno = n.dbserno
where (
        o.dbserno is null
    )
    or (
        n.dbserno is null
    )
    or (
        o.accountno <> n.accountno
        or o.sealcardno <> n.sealcardno
        or o.areano <> n.areano
        or o.oldcardno <> n.oldcardno
        or o.cardprintno <> n.cardprintno
        or o.branchno <> n.branchno
        or o.siteno <> n.siteno
        or o.subjectno <> n.subjectno
        or o.name <> n.name
        or o.address <> n.address
        or o.postcode <> n.postcode
        or o.noteex <> n.noteex
        or o.contactman <> n.contactman
        or o.contactphone <> n.contactphone
        or o.email <> n.email
        or o.personalid <> n.personalid
        or o.quality <> n.quality
        or o.type <> n.type
        or o.monittype <> n.monittype
        or o.opendate <> n.opendate
        or o.destroydate <> n.destroydate
        or o.operator <> n.operator
        or o.checker <> n.checker
        or o.sealcount <> n.sealcount
        or o.siteid <> n.siteid
        or o.createdate <> n.createdate
        or o.usedate <> n.usedate
        or o.stopdate <> n.stopdate
        or o.drawoutdate <> n.drawoutdate
        or o.state <> n.state
        or o.checkflag <> n.checkflag
        or o.destroyflag <> n.destroyflag
        or o.loseflag <> n.loseflag
        or o.acctproperty <> n.acctproperty
        or o.billtype <> n.billtype
        or o.flagfield <> n.flagfield
        or o.suspectnote <> n.suspectnote
        or o.mainaccno <> n.mainaccno
        or o.reservedchar1 <> n.reservedchar1
        or o.reservedchar2 <> n.reservedchar2
        or o.reservedchar3 <> n.reservedchar3
        or o.reservedchar4 <> n.reservedchar4
        or o.belongflag <> n.belongflag
        or o.password <> n.password
        or o.workdate <> n.workdate
        or o.systemdate <> n.systemdate
        or o.verifycombination <> n.verifycombination
        or o.datamac <> n.datamac
        or o.imgmac <> n.imgmac
        or o.imglen <> n.imglen
        or o.sealimages <> n.sealimages
        or o.standbyamount <> n.standbyamount
        or o.accountstate <> n.accountstate
        or o.prescanimageid <> n.prescanimageid
        or o.prescanflag <> n.prescanflag
        or o.printcount <> n.printcount
        or o.modifyflag <> n.modifyflag
        or o.custno <> n.custno
        or o.custname <> n.custname
        or o.other1 <> n.other1
        or o.other2 <> n.other2
        or o.other3 <> n.other3
        or o.checkbranchno <> n.checkbranchno
        or o.collectbranchno <> n.collectbranchno
        or o.precollectflag <> n.precollectflag
        or o.acctype <> n.acctype
        or o.qualitybranch <> n.qualitybranch
        or o.freezedate <> n.freezedate
        or o.freezeflag <> n.freezeflag
        or o.open_user <> n.open_user
        or o.rebuild_combo <> n.rebuild_combo
        or o.card_status <> n.card_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dsvp_seal_custaccount_cl(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,areano -- 地区代码
            ,oldcardno -- 旧印鉴卡序号
            ,cardprintno -- 印鉴卡号
            ,branchno -- 机构编号
            ,siteno -- 建模机构编号
            ,subjectno -- 科目编号
            ,name -- 账户名称
            ,address -- 地址
            ,postcode -- 邮政编号
            ,noteex -- 备注
            ,contactman -- 联系人
            ,contactphone -- 联系电话
            ,email -- 邮箱
            ,personalid -- 身份证编号
            ,quality -- 通兑标识（1-通存通兑，2-非通存通兑）
            ,type -- 预留字段0
            ,monittype -- 监控标识（0-正常，1-监控户，2-关注户）
            ,opendate -- 开户日期
            ,destroydate -- 销户日期
            ,operator -- 员工编号
            ,checker -- 员工编号
            ,sealcount -- 印章数量
            ,siteid -- 节点号
            ,createdate -- 建模日期
            ,usedate -- 启用日期
            ,stopdate -- 停用日期
            ,drawoutdate -- 抽卡日期
            ,state -- 印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）
            ,checkflag -- 复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）
            ,destroyflag -- 销户标识（0-正常，1-销户）
            ,loseflag -- 挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）
            ,acctproperty -- 账户性质
            ,billtype -- 币种编号
            ,flagfield -- 标识域
            ,suspectnote -- 监控备注
            ,mainaccno -- 主账号
            ,reservedchar1 -- 预留字段1
            ,reservedchar2 -- 退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）
            ,reservedchar3 -- 退回理由
            ,reservedchar4 -- 预留字段4
            ,belongflag -- 共用标识（0-非共用，1-主账户，2-从账户）
            ,password -- 密码
            ,workdate -- 工作日期
            ,systemdate -- 系统日期
            ,verifycombination -- 验印组合
            ,datamac -- 数据MAC
            ,imgmac -- 图像MAC
            ,imglen -- 图像大小
            ,sealimages -- 印章信息
            ,standbyamount -- 保证金金额
            ,accountstate -- 账户状态
            ,prescanimageid -- 图像编号
            ,prescanflag -- 采集标识（0-否，1-是）
            ,printcount -- 打印次数
            ,modifyflag -- 修改标识（0-未校验，1-已校验）
            ,custno -- 核心客户号
            ,custname -- 客户名称
            ,other1 -- 预留字段3
            ,other2 -- 预留字段4
            ,other3 -- 预留字段5
            ,checkbranchno -- 复核机构编号
            ,collectbranchno -- 采集机构编号
            ,precollectflag -- 预采集标识
            ,acctype -- 账户类型
            ,qualitybranch -- 指定机构通兑
            ,freezedate -- 挂失日志————--借用冻结日期
            ,freezeflag -- 
            ,open_user -- 账户的开户柜员号
            ,rebuild_combo -- 重建验印组合标志（"0"-非重建组合 "1"-重建组合）
            ,card_status -- 最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dsvp_seal_custaccount_op(
            dbserno -- 编号
            ,accountno -- 账号
            ,sealcardno -- 印鉴卡序号
            ,areano -- 地区代码
            ,oldcardno -- 旧印鉴卡序号
            ,cardprintno -- 印鉴卡号
            ,branchno -- 机构编号
            ,siteno -- 建模机构编号
            ,subjectno -- 科目编号
            ,name -- 账户名称
            ,address -- 地址
            ,postcode -- 邮政编号
            ,noteex -- 备注
            ,contactman -- 联系人
            ,contactphone -- 联系电话
            ,email -- 邮箱
            ,personalid -- 身份证编号
            ,quality -- 通兑标识（1-通存通兑，2-非通存通兑）
            ,type -- 预留字段0
            ,monittype -- 监控标识（0-正常，1-监控户，2-关注户）
            ,opendate -- 开户日期
            ,destroydate -- 销户日期
            ,operator -- 员工编号
            ,checker -- 员工编号
            ,sealcount -- 印章数量
            ,siteid -- 节点号
            ,createdate -- 建模日期
            ,usedate -- 启用日期
            ,stopdate -- 停用日期
            ,drawoutdate -- 抽卡日期
            ,state -- 印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）
            ,checkflag -- 复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）
            ,destroyflag -- 销户标识（0-正常，1-销户）
            ,loseflag -- 挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）
            ,acctproperty -- 账户性质
            ,billtype -- 币种编号
            ,flagfield -- 标识域
            ,suspectnote -- 监控备注
            ,mainaccno -- 主账号
            ,reservedchar1 -- 预留字段1
            ,reservedchar2 -- 退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）
            ,reservedchar3 -- 退回理由
            ,reservedchar4 -- 预留字段4
            ,belongflag -- 共用标识（0-非共用，1-主账户，2-从账户）
            ,password -- 密码
            ,workdate -- 工作日期
            ,systemdate -- 系统日期
            ,verifycombination -- 验印组合
            ,datamac -- 数据MAC
            ,imgmac -- 图像MAC
            ,imglen -- 图像大小
            ,sealimages -- 印章信息
            ,standbyamount -- 保证金金额
            ,accountstate -- 账户状态
            ,prescanimageid -- 图像编号
            ,prescanflag -- 采集标识（0-否，1-是）
            ,printcount -- 打印次数
            ,modifyflag -- 修改标识（0-未校验，1-已校验）
            ,custno -- 核心客户号
            ,custname -- 客户名称
            ,other1 -- 预留字段3
            ,other2 -- 预留字段4
            ,other3 -- 预留字段5
            ,checkbranchno -- 复核机构编号
            ,collectbranchno -- 采集机构编号
            ,precollectflag -- 预采集标识
            ,acctype -- 账户类型
            ,qualitybranch -- 指定机构通兑
            ,freezedate -- 挂失日志————--借用冻结日期
            ,freezeflag -- 
            ,open_user -- 账户的开户柜员号
            ,rebuild_combo -- 重建验印组合标志（"0"-非重建组合 "1"-重建组合）
            ,card_status -- 最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dbserno -- 编号
    ,o.accountno -- 账号
    ,o.sealcardno -- 印鉴卡序号
    ,o.areano -- 地区代码
    ,o.oldcardno -- 旧印鉴卡序号
    ,o.cardprintno -- 印鉴卡号
    ,o.branchno -- 机构编号
    ,o.siteno -- 建模机构编号
    ,o.subjectno -- 科目编号
    ,o.name -- 账户名称
    ,o.address -- 地址
    ,o.postcode -- 邮政编号
    ,o.noteex -- 备注
    ,o.contactman -- 联系人
    ,o.contactphone -- 联系电话
    ,o.email -- 邮箱
    ,o.personalid -- 身份证编号
    ,o.quality -- 通兑标识（1-通存通兑，2-非通存通兑）
    ,o.type -- 预留字段0
    ,o.monittype -- 监控标识（0-正常，1-监控户，2-关注户）
    ,o.opendate -- 开户日期
    ,o.destroydate -- 销户日期
    ,o.operator -- 员工编号
    ,o.checker -- 员工编号
    ,o.sealcount -- 印章数量
    ,o.siteid -- 节点号
    ,o.createdate -- 建模日期
    ,o.usedate -- 启用日期
    ,o.stopdate -- 停用日期
    ,o.drawoutdate -- 抽卡日期
    ,o.state -- 印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）
    ,o.checkflag -- 复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）
    ,o.destroyflag -- 销户标识（0-正常，1-销户）
    ,o.loseflag -- 挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）
    ,o.acctproperty -- 账户性质
    ,o.billtype -- 币种编号
    ,o.flagfield -- 标识域
    ,o.suspectnote -- 监控备注
    ,o.mainaccno -- 主账号
    ,o.reservedchar1 -- 预留字段1
    ,o.reservedchar2 -- 退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）
    ,o.reservedchar3 -- 退回理由
    ,o.reservedchar4 -- 预留字段4
    ,o.belongflag -- 共用标识（0-非共用，1-主账户，2-从账户）
    ,o.password -- 密码
    ,o.workdate -- 工作日期
    ,o.systemdate -- 系统日期
    ,o.verifycombination -- 验印组合
    ,o.datamac -- 数据MAC
    ,o.imgmac -- 图像MAC
    ,o.imglen -- 图像大小
    ,o.sealimages -- 印章信息
    ,o.standbyamount -- 保证金金额
    ,o.accountstate -- 账户状态
    ,o.prescanimageid -- 图像编号
    ,o.prescanflag -- 采集标识（0-否，1-是）
    ,o.printcount -- 打印次数
    ,o.modifyflag -- 修改标识（0-未校验，1-已校验）
    ,o.custno -- 核心客户号
    ,o.custname -- 客户名称
    ,o.other1 -- 预留字段3
    ,o.other2 -- 预留字段4
    ,o.other3 -- 预留字段5
    ,o.checkbranchno -- 复核机构编号
    ,o.collectbranchno -- 采集机构编号
    ,o.precollectflag -- 预采集标识
    ,o.acctype -- 账户类型
    ,o.qualitybranch -- 指定机构通兑
    ,o.freezedate -- 挂失日志————--借用冻结日期
    ,o.freezeflag -- 
    ,o.open_user -- 账户的开户柜员号
    ,o.rebuild_combo -- 重建验印组合标志（"0"-非重建组合 "1"-重建组合）
    ,o.card_status -- 最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)
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
from ${iol_schema}.dsvp_seal_custaccount_bk o
    left join ${iol_schema}.dsvp_seal_custaccount_op n
        on
            o.dbserno = n.dbserno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.dsvp_seal_custaccount_cl d
        on
            o.dbserno = d.dbserno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.dsvp_seal_custaccount;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('dsvp_seal_custaccount') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.dsvp_seal_custaccount drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.dsvp_seal_custaccount add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.dsvp_seal_custaccount exchange partition p_${batch_date} with table ${iol_schema}.dsvp_seal_custaccount_cl;
alter table ${iol_schema}.dsvp_seal_custaccount exchange partition p_20991231 with table ${iol_schema}.dsvp_seal_custaccount_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.dsvp_seal_custaccount to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dsvp_seal_custaccount_op purge;
drop table ${iol_schema}.dsvp_seal_custaccount_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.dsvp_seal_custaccount_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'dsvp_seal_custaccount',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);

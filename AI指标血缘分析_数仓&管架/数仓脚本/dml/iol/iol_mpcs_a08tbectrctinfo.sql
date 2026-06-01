/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08tbectrctinfo
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
create table ${iol_schema}.mpcs_a08tbectrctinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08tbectrctinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tbectrctinfo_op purge;
drop table ${iol_schema}.mpcs_a08tbectrctinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbectrctinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tbectrctinfo where 0=1;

create table ${iol_schema}.mpcs_a08tbectrctinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tbectrctinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tbectrctinfo_cl(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,ctrctsgndt -- 协议签署日期
            ,ctrctnb -- 协议号
            ,sndupbrn -- 发起直接参与机构
            ,payflag -- 收付款标识 P-付款方 R-收款方
            ,ctrcttp -- 协议类型
            ,nbofpmtitms -- 费项数目
            ,pmtitmcds -- 费项代码集合
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,payacct -- 付款人账号
            ,payname -- 付款人名称
            ,incoacct -- 收款人账号
            ,inconame -- 收款人名称
            ,cstmraccttype -- 付款人账户类型
            ,payopenbrn -- 付款人开户行
            ,idtp -- 付款人证件类型
            ,id -- 付款人证件号码
            ,telnb -- 付款人手机号码(银行预留手机号码)
            ,adrline -- 地址
            ,ctrctduedt -- 协议到期日
            ,ectdt -- 生效日期
            ,oncddctnlmt -- 一次性扣款限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,cycddctnlmt -- 扣款周期内扣费限额
            ,tmut -- 扣款时间单位
            ,tmsp -- 扣款时间步长
            ,tmdc -- 扣款时间描述
            ,ctrctaddtlinf -- 协议附加数据
            ,signsts -- 协议状态 Z-初始登记 1-已生效 0-已失效 C-已撤销 W-待授权 R-被拒绝
            ,errmsg -- 错误信息
            ,uptm -- 更新时间
            ,authurl -- 认证URL
            ,otpseqno -- 短信认证流水
            ,regid -- 区域标识
            ,paybrn -- 付款行
            ,paybanknm -- 付款行行名
            ,incobrn -- 收款行
            ,incobanknm -- 收款行行名
            ,unisoccdtcd -- 统一社会信用代码
            ,iotype -- 来往标识
            ,authmd -- 授权模式
            ,magbrn -- 处理机构
            ,remark -- 附言
            ,dealflag -- 全行处理标识
            ,openbrn -- 开户机构
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员号
            ,srcseqno -- 原渠道流水
            ,mutrcd -- 菜单码
            ,isstock -- 是否为存量协议 1-是
            ,orictrctnb -- 初始协议号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tbectrctinfo_op(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,ctrctsgndt -- 协议签署日期
            ,ctrctnb -- 协议号
            ,sndupbrn -- 发起直接参与机构
            ,payflag -- 收付款标识 P-付款方 R-收款方
            ,ctrcttp -- 协议类型
            ,nbofpmtitms -- 费项数目
            ,pmtitmcds -- 费项代码集合
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,payacct -- 付款人账号
            ,payname -- 付款人名称
            ,incoacct -- 收款人账号
            ,inconame -- 收款人名称
            ,cstmraccttype -- 付款人账户类型
            ,payopenbrn -- 付款人开户行
            ,idtp -- 付款人证件类型
            ,id -- 付款人证件号码
            ,telnb -- 付款人手机号码(银行预留手机号码)
            ,adrline -- 地址
            ,ctrctduedt -- 协议到期日
            ,ectdt -- 生效日期
            ,oncddctnlmt -- 一次性扣款限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,cycddctnlmt -- 扣款周期内扣费限额
            ,tmut -- 扣款时间单位
            ,tmsp -- 扣款时间步长
            ,tmdc -- 扣款时间描述
            ,ctrctaddtlinf -- 协议附加数据
            ,signsts -- 协议状态 Z-初始登记 1-已生效 0-已失效 C-已撤销 W-待授权 R-被拒绝
            ,errmsg -- 错误信息
            ,uptm -- 更新时间
            ,authurl -- 认证URL
            ,otpseqno -- 短信认证流水
            ,regid -- 区域标识
            ,paybrn -- 付款行
            ,paybanknm -- 付款行行名
            ,incobrn -- 收款行
            ,incobanknm -- 收款行行名
            ,unisoccdtcd -- 统一社会信用代码
            ,iotype -- 来往标识
            ,authmd -- 授权模式
            ,magbrn -- 处理机构
            ,remark -- 附言
            ,dealflag -- 全行处理标识
            ,openbrn -- 开户机构
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员号
            ,srcseqno -- 原渠道流水
            ,mutrcd -- 菜单码
            ,isstock -- 是否为存量协议 1-是
            ,orictrctnb -- 初始协议号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.transtm, o.transtm) as transtm -- 交易时间
    ,nvl(n.ctrctsgndt, o.ctrctsgndt) as ctrctsgndt -- 协议签署日期
    ,nvl(n.ctrctnb, o.ctrctnb) as ctrctnb -- 协议号
    ,nvl(n.sndupbrn, o.sndupbrn) as sndupbrn -- 发起直接参与机构
    ,nvl(n.payflag, o.payflag) as payflag -- 收付款标识 P-付款方 R-收款方
    ,nvl(n.ctrcttp, o.ctrcttp) as ctrcttp -- 协议类型
    ,nvl(n.nbofpmtitms, o.nbofpmtitms) as nbofpmtitms -- 费项数目
    ,nvl(n.pmtitmcds, o.pmtitmcds) as pmtitmcds -- 费项代码集合
    ,nvl(n.cstmrid, o.cstmrid) as cstmrid -- 客户号
    ,nvl(n.cstmrnm, o.cstmrnm) as cstmrnm -- 客户名称
    ,nvl(n.payacct, o.payacct) as payacct -- 付款人账号
    ,nvl(n.payname, o.payname) as payname -- 付款人名称
    ,nvl(n.incoacct, o.incoacct) as incoacct -- 收款人账号
    ,nvl(n.inconame, o.inconame) as inconame -- 收款人名称
    ,nvl(n.cstmraccttype, o.cstmraccttype) as cstmraccttype -- 付款人账户类型
    ,nvl(n.payopenbrn, o.payopenbrn) as payopenbrn -- 付款人开户行
    ,nvl(n.idtp, o.idtp) as idtp -- 付款人证件类型
    ,nvl(n.id, o.id) as id -- 付款人证件号码
    ,nvl(n.telnb, o.telnb) as telnb -- 付款人手机号码(银行预留手机号码)
    ,nvl(n.adrline, o.adrline) as adrline -- 地址
    ,nvl(n.ctrctduedt, o.ctrctduedt) as ctrctduedt -- 协议到期日
    ,nvl(n.ectdt, o.ectdt) as ectdt -- 生效日期
    ,nvl(n.oncddctnlmt, o.oncddctnlmt) as oncddctnlmt -- 一次性扣款限额
    ,nvl(n.cycddctnnumlmt, o.cycddctnnumlmt) as cycddctnnumlmt -- 扣款周期内限制笔数
    ,nvl(n.cycddctnlmt, o.cycddctnlmt) as cycddctnlmt -- 扣款周期内扣费限额
    ,nvl(n.tmut, o.tmut) as tmut -- 扣款时间单位
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 扣款时间步长
    ,nvl(n.tmdc, o.tmdc) as tmdc -- 扣款时间描述
    ,nvl(n.ctrctaddtlinf, o.ctrctaddtlinf) as ctrctaddtlinf -- 协议附加数据
    ,nvl(n.signsts, o.signsts) as signsts -- 协议状态 Z-初始登记 1-已生效 0-已失效 C-已撤销 W-待授权 R-被拒绝
    ,nvl(n.errmsg, o.errmsg) as errmsg -- 错误信息
    ,nvl(n.uptm, o.uptm) as uptm -- 更新时间
    ,nvl(n.authurl, o.authurl) as authurl -- 认证URL
    ,nvl(n.otpseqno, o.otpseqno) as otpseqno -- 短信认证流水
    ,nvl(n.regid, o.regid) as regid -- 区域标识
    ,nvl(n.paybrn, o.paybrn) as paybrn -- 付款行
    ,nvl(n.paybanknm, o.paybanknm) as paybanknm -- 付款行行名
    ,nvl(n.incobrn, o.incobrn) as incobrn -- 收款行
    ,nvl(n.incobanknm, o.incobanknm) as incobanknm -- 收款行行名
    ,nvl(n.unisoccdtcd, o.unisoccdtcd) as unisoccdtcd -- 统一社会信用代码
    ,nvl(n.iotype, o.iotype) as iotype -- 来往标识
    ,nvl(n.authmd, o.authmd) as authmd -- 授权模式
    ,nvl(n.magbrn, o.magbrn) as magbrn -- 处理机构
    ,nvl(n.remark, o.remark) as remark -- 附言
    ,nvl(n.dealflag, o.dealflag) as dealflag -- 全行处理标识
    ,nvl(n.openbrn, o.openbrn) as openbrn -- 开户机构
    ,nvl(n.brcno, o.brcno) as brcno -- 交易机构
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 交易柜员
    ,nvl(n.authtlrno, o.authtlrno) as authtlrno -- 授权柜员号
    ,nvl(n.srcseqno, o.srcseqno) as srcseqno -- 原渠道流水
    ,nvl(n.mutrcd, o.mutrcd) as mutrcd -- 菜单码
    ,nvl(n.isstock, o.isstock) as isstock -- 是否为存量协议 1-是
    ,nvl(n.orictrctnb, o.orictrctnb) as orictrctnb -- 初始协议号
    ,case when
            n.ctrctsgndt is null
            and n.ctrctnb is null
            and n.sndupbrn is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ctrctsgndt is null
            and n.ctrctnb is null
            and n.sndupbrn is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ctrctsgndt is null
            and n.ctrctnb is null
            and n.sndupbrn is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a08tbectrctinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08tbectrctinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ctrctsgndt = n.ctrctsgndt
            and o.ctrctnb = n.ctrctnb
            and o.sndupbrn = n.sndupbrn
where (
        o.ctrctsgndt is null
        and o.ctrctnb is null
        and o.sndupbrn is null
    )
    or (
        n.ctrctsgndt is null
        and n.ctrctnb is null
        and n.sndupbrn is null
    )
    or (
        o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.payflag <> n.payflag
        or o.ctrcttp <> n.ctrcttp
        or o.nbofpmtitms <> n.nbofpmtitms
        or o.pmtitmcds <> n.pmtitmcds
        or o.cstmrid <> n.cstmrid
        or o.cstmrnm <> n.cstmrnm
        or o.payacct <> n.payacct
        or o.payname <> n.payname
        or o.incoacct <> n.incoacct
        or o.inconame <> n.inconame
        or o.cstmraccttype <> n.cstmraccttype
        or o.payopenbrn <> n.payopenbrn
        or o.idtp <> n.idtp
        or o.id <> n.id
        or o.telnb <> n.telnb
        or o.adrline <> n.adrline
        or o.ctrctduedt <> n.ctrctduedt
        or o.ectdt <> n.ectdt
        or o.oncddctnlmt <> n.oncddctnlmt
        or o.cycddctnnumlmt <> n.cycddctnnumlmt
        or o.cycddctnlmt <> n.cycddctnlmt
        or o.tmut <> n.tmut
        or o.tmsp <> n.tmsp
        or o.tmdc <> n.tmdc
        or o.ctrctaddtlinf <> n.ctrctaddtlinf
        or o.signsts <> n.signsts
        or o.errmsg <> n.errmsg
        or o.uptm <> n.uptm
        or o.authurl <> n.authurl
        or o.otpseqno <> n.otpseqno
        or o.regid <> n.regid
        or o.paybrn <> n.paybrn
        or o.paybanknm <> n.paybanknm
        or o.incobrn <> n.incobrn
        or o.incobanknm <> n.incobanknm
        or o.unisoccdtcd <> n.unisoccdtcd
        or o.iotype <> n.iotype
        or o.authmd <> n.authmd
        or o.magbrn <> n.magbrn
        or o.remark <> n.remark
        or o.dealflag <> n.dealflag
        or o.openbrn <> n.openbrn
        or o.brcno <> n.brcno
        or o.tlrno <> n.tlrno
        or o.authtlrno <> n.authtlrno
        or o.srcseqno <> n.srcseqno
        or o.mutrcd <> n.mutrcd
        or o.isstock <> n.isstock
        or o.orictrctnb <> n.orictrctnb
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tbectrctinfo_cl(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,ctrctsgndt -- 协议签署日期
            ,ctrctnb -- 协议号
            ,sndupbrn -- 发起直接参与机构
            ,payflag -- 收付款标识 P-付款方 R-收款方
            ,ctrcttp -- 协议类型
            ,nbofpmtitms -- 费项数目
            ,pmtitmcds -- 费项代码集合
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,payacct -- 付款人账号
            ,payname -- 付款人名称
            ,incoacct -- 收款人账号
            ,inconame -- 收款人名称
            ,cstmraccttype -- 付款人账户类型
            ,payopenbrn -- 付款人开户行
            ,idtp -- 付款人证件类型
            ,id -- 付款人证件号码
            ,telnb -- 付款人手机号码(银行预留手机号码)
            ,adrline -- 地址
            ,ctrctduedt -- 协议到期日
            ,ectdt -- 生效日期
            ,oncddctnlmt -- 一次性扣款限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,cycddctnlmt -- 扣款周期内扣费限额
            ,tmut -- 扣款时间单位
            ,tmsp -- 扣款时间步长
            ,tmdc -- 扣款时间描述
            ,ctrctaddtlinf -- 协议附加数据
            ,signsts -- 协议状态 Z-初始登记 1-已生效 0-已失效 C-已撤销 W-待授权 R-被拒绝
            ,errmsg -- 错误信息
            ,uptm -- 更新时间
            ,authurl -- 认证URL
            ,otpseqno -- 短信认证流水
            ,regid -- 区域标识
            ,paybrn -- 付款行
            ,paybanknm -- 付款行行名
            ,incobrn -- 收款行
            ,incobanknm -- 收款行行名
            ,unisoccdtcd -- 统一社会信用代码
            ,iotype -- 来往标识
            ,authmd -- 授权模式
            ,magbrn -- 处理机构
            ,remark -- 附言
            ,dealflag -- 全行处理标识
            ,openbrn -- 开户机构
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员号
            ,srcseqno -- 原渠道流水
            ,mutrcd -- 菜单码
            ,isstock -- 是否为存量协议 1-是
            ,orictrctnb -- 初始协议号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tbectrctinfo_op(
            transdt -- 交易日期
            ,transtm -- 交易时间
            ,ctrctsgndt -- 协议签署日期
            ,ctrctnb -- 协议号
            ,sndupbrn -- 发起直接参与机构
            ,payflag -- 收付款标识 P-付款方 R-收款方
            ,ctrcttp -- 协议类型
            ,nbofpmtitms -- 费项数目
            ,pmtitmcds -- 费项代码集合
            ,cstmrid -- 客户号
            ,cstmrnm -- 客户名称
            ,payacct -- 付款人账号
            ,payname -- 付款人名称
            ,incoacct -- 收款人账号
            ,inconame -- 收款人名称
            ,cstmraccttype -- 付款人账户类型
            ,payopenbrn -- 付款人开户行
            ,idtp -- 付款人证件类型
            ,id -- 付款人证件号码
            ,telnb -- 付款人手机号码(银行预留手机号码)
            ,adrline -- 地址
            ,ctrctduedt -- 协议到期日
            ,ectdt -- 生效日期
            ,oncddctnlmt -- 一次性扣款限额
            ,cycddctnnumlmt -- 扣款周期内限制笔数
            ,cycddctnlmt -- 扣款周期内扣费限额
            ,tmut -- 扣款时间单位
            ,tmsp -- 扣款时间步长
            ,tmdc -- 扣款时间描述
            ,ctrctaddtlinf -- 协议附加数据
            ,signsts -- 协议状态 Z-初始登记 1-已生效 0-已失效 C-已撤销 W-待授权 R-被拒绝
            ,errmsg -- 错误信息
            ,uptm -- 更新时间
            ,authurl -- 认证URL
            ,otpseqno -- 短信认证流水
            ,regid -- 区域标识
            ,paybrn -- 付款行
            ,paybanknm -- 付款行行名
            ,incobrn -- 收款行
            ,incobanknm -- 收款行行名
            ,unisoccdtcd -- 统一社会信用代码
            ,iotype -- 来往标识
            ,authmd -- 授权模式
            ,magbrn -- 处理机构
            ,remark -- 附言
            ,dealflag -- 全行处理标识
            ,openbrn -- 开户机构
            ,brcno -- 交易机构
            ,tlrno -- 交易柜员
            ,authtlrno -- 授权柜员号
            ,srcseqno -- 原渠道流水
            ,mutrcd -- 菜单码
            ,isstock -- 是否为存量协议 1-是
            ,orictrctnb -- 初始协议号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.transdt -- 交易日期
    ,o.transtm -- 交易时间
    ,o.ctrctsgndt -- 协议签署日期
    ,o.ctrctnb -- 协议号
    ,o.sndupbrn -- 发起直接参与机构
    ,o.payflag -- 收付款标识 P-付款方 R-收款方
    ,o.ctrcttp -- 协议类型
    ,o.nbofpmtitms -- 费项数目
    ,o.pmtitmcds -- 费项代码集合
    ,o.cstmrid -- 客户号
    ,o.cstmrnm -- 客户名称
    ,o.payacct -- 付款人账号
    ,o.payname -- 付款人名称
    ,o.incoacct -- 收款人账号
    ,o.inconame -- 收款人名称
    ,o.cstmraccttype -- 付款人账户类型
    ,o.payopenbrn -- 付款人开户行
    ,o.idtp -- 付款人证件类型
    ,o.id -- 付款人证件号码
    ,o.telnb -- 付款人手机号码(银行预留手机号码)
    ,o.adrline -- 地址
    ,o.ctrctduedt -- 协议到期日
    ,o.ectdt -- 生效日期
    ,o.oncddctnlmt -- 一次性扣款限额
    ,o.cycddctnnumlmt -- 扣款周期内限制笔数
    ,o.cycddctnlmt -- 扣款周期内扣费限额
    ,o.tmut -- 扣款时间单位
    ,o.tmsp -- 扣款时间步长
    ,o.tmdc -- 扣款时间描述
    ,o.ctrctaddtlinf -- 协议附加数据
    ,o.signsts -- 协议状态 Z-初始登记 1-已生效 0-已失效 C-已撤销 W-待授权 R-被拒绝
    ,o.errmsg -- 错误信息
    ,o.uptm -- 更新时间
    ,o.authurl -- 认证URL
    ,o.otpseqno -- 短信认证流水
    ,o.regid -- 区域标识
    ,o.paybrn -- 付款行
    ,o.paybanknm -- 付款行行名
    ,o.incobrn -- 收款行
    ,o.incobanknm -- 收款行行名
    ,o.unisoccdtcd -- 统一社会信用代码
    ,o.iotype -- 来往标识
    ,o.authmd -- 授权模式
    ,o.magbrn -- 处理机构
    ,o.remark -- 附言
    ,o.dealflag -- 全行处理标识
    ,o.openbrn -- 开户机构
    ,o.brcno -- 交易机构
    ,o.tlrno -- 交易柜员
    ,o.authtlrno -- 授权柜员号
    ,o.srcseqno -- 原渠道流水
    ,o.mutrcd -- 菜单码
    ,o.isstock -- 是否为存量协议 1-是
    ,o.orictrctnb -- 初始协议号
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
from ${iol_schema}.mpcs_a08tbectrctinfo_bk o
    left join ${iol_schema}.mpcs_a08tbectrctinfo_op n
        on
            o.ctrctsgndt = n.ctrctsgndt
            and o.ctrctnb = n.ctrctnb
            and o.sndupbrn = n.sndupbrn
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08tbectrctinfo_cl d
        on
            o.ctrctsgndt = d.ctrctsgndt
            and o.ctrctnb = d.ctrctnb
            and o.sndupbrn = d.sndupbrn
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a08tbectrctinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a08tbectrctinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a08tbectrctinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a08tbectrctinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a08tbectrctinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a08tbectrctinfo_cl;
alter table ${iol_schema}.mpcs_a08tbectrctinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a08tbectrctinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08tbectrctinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tbectrctinfo_op purge;
drop table ${iol_schema}.mpcs_a08tbectrctinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08tbectrctinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08tbectrctinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);

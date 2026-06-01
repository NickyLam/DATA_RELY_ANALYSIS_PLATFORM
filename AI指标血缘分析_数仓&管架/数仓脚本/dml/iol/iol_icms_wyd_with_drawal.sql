/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wyd_with_drawal
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
create table ${iol_schema}.icms_wyd_with_drawal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wyd_with_drawal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_with_drawal_op purge;
drop table ${iol_schema}.icms_wyd_with_drawal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_with_drawal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_with_drawal where 0=1;

create table ${iol_schema}.icms_wyd_with_drawal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wyd_with_drawal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_with_drawal_cl(
            serialno -- 流水号
            ,coorgnum -- 合作机构号
            ,applseqnum -- 申请流水号
            ,lrrserialno -- 微业贷额度结果接收流水号
            ,intfccalltm -- 接口调用时间
            ,stlprdcd -- 核算产品代码
            ,ddtyp -- 放款类型
            ,refe -- 推荐人
            ,ccy -- 币种
            ,contramt -- 合同金额
            ,precdddate -- 预约放款日期
            ,applsiteregion -- 申请地点区划
            ,applusage -- 申请用途
            ,wzguarmode -- 微众担保方式
            ,dedudate -- 扣款日
            ,taxpidennum -- 纳税人识别号
            ,corpfname -- 企业全称
            ,ptyecif -- 客户CCIF
            ,regctyzone -- 注册国家或地区
            ,natnregion -- 注册地行政区划
            ,regloc -- 注册地址
            ,prov -- 省份
            ,orgcd -- 组织机构代码
            ,csldsocicrdtid -- 统一社会信用编号
            ,inducomregnum -- 工商注册号
            ,operlicencevalidenddt -- 营业执照有效截止日期
            ,gbinduclass -- 国标行业分类
            ,wzcorpsize -- 微众企业规模
            ,cbrcsmallcorpind -- 银监会小企业标识
            ,estabdt -- 成立日期
            ,operyears -- 经营年限
            ,empcnt -- 员工人数
            ,lpname -- 法定代表人名称
            ,lpecif -- 法人ECIF
            ,lpcerttyp -- 法人证件类型
            ,lpcertnum -- 法人证件号码
            ,lpcertexpidate -- 法人证件失效日期
            ,lpgend -- 法人性别
            ,lpethnic -- 法人民族
            ,lpcertadr -- 法人证件地址
            ,lpnation -- 法人国籍
            ,lpcareer -- 法人职业
            ,lpbirthdt -- 法人出生日期
            ,lpcephnum -- 法人手机号码
            ,certbankcardnum -- 认证银行卡号
            ,certcephnum -- 认证手机号码
            ,corpcitauthsigntm -- 企业征信授权书签署时间
            ,indvcitauthsigntm -- 个人征信授权书签署时间
            ,corpcitauthsignseq -- 企业征信授权书签署流水号
            ,indvcitauthsignseq -- 个人征信授权书签署流水号
            ,facecertresu -- 人脸认证结果
            ,finalcfmlmt -- 最终确认额度
            ,modelquotalmt -- 模型核额额度
            ,coopupdalmt -- 合作方修改额度
            ,lastchklmtdate -- 最近核额时间
            ,interrat -- 内部评级
            ,loancnt -- 贷款笔数
            ,loanform -- 贷款形式
            ,origdbillnum -- 原借据号
            ,wthrguarbiz -- 是否担保业务
            ,guartcompanyname -- 担保公司名称
            ,guarcorpcerttyp -- 担保公司证件类型
            ,guarcorpcertnum -- 担保公司证件号码
            ,guarratio -- 担保比例
            ,customerid -- 客户编号
            ,riskresult -- 风控结果
            ,isfirstloan -- 是否首贷
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_with_drawal_op(
            serialno -- 流水号
            ,coorgnum -- 合作机构号
            ,applseqnum -- 申请流水号
            ,lrrserialno -- 微业贷额度结果接收流水号
            ,intfccalltm -- 接口调用时间
            ,stlprdcd -- 核算产品代码
            ,ddtyp -- 放款类型
            ,refe -- 推荐人
            ,ccy -- 币种
            ,contramt -- 合同金额
            ,precdddate -- 预约放款日期
            ,applsiteregion -- 申请地点区划
            ,applusage -- 申请用途
            ,wzguarmode -- 微众担保方式
            ,dedudate -- 扣款日
            ,taxpidennum -- 纳税人识别号
            ,corpfname -- 企业全称
            ,ptyecif -- 客户CCIF
            ,regctyzone -- 注册国家或地区
            ,natnregion -- 注册地行政区划
            ,regloc -- 注册地址
            ,prov -- 省份
            ,orgcd -- 组织机构代码
            ,csldsocicrdtid -- 统一社会信用编号
            ,inducomregnum -- 工商注册号
            ,operlicencevalidenddt -- 营业执照有效截止日期
            ,gbinduclass -- 国标行业分类
            ,wzcorpsize -- 微众企业规模
            ,cbrcsmallcorpind -- 银监会小企业标识
            ,estabdt -- 成立日期
            ,operyears -- 经营年限
            ,empcnt -- 员工人数
            ,lpname -- 法定代表人名称
            ,lpecif -- 法人ECIF
            ,lpcerttyp -- 法人证件类型
            ,lpcertnum -- 法人证件号码
            ,lpcertexpidate -- 法人证件失效日期
            ,lpgend -- 法人性别
            ,lpethnic -- 法人民族
            ,lpcertadr -- 法人证件地址
            ,lpnation -- 法人国籍
            ,lpcareer -- 法人职业
            ,lpbirthdt -- 法人出生日期
            ,lpcephnum -- 法人手机号码
            ,certbankcardnum -- 认证银行卡号
            ,certcephnum -- 认证手机号码
            ,corpcitauthsigntm -- 企业征信授权书签署时间
            ,indvcitauthsigntm -- 个人征信授权书签署时间
            ,corpcitauthsignseq -- 企业征信授权书签署流水号
            ,indvcitauthsignseq -- 个人征信授权书签署流水号
            ,facecertresu -- 人脸认证结果
            ,finalcfmlmt -- 最终确认额度
            ,modelquotalmt -- 模型核额额度
            ,coopupdalmt -- 合作方修改额度
            ,lastchklmtdate -- 最近核额时间
            ,interrat -- 内部评级
            ,loancnt -- 贷款笔数
            ,loanform -- 贷款形式
            ,origdbillnum -- 原借据号
            ,wthrguarbiz -- 是否担保业务
            ,guartcompanyname -- 担保公司名称
            ,guarcorpcerttyp -- 担保公司证件类型
            ,guarcorpcertnum -- 担保公司证件号码
            ,guarratio -- 担保比例
            ,customerid -- 客户编号
            ,riskresult -- 风控结果
            ,isfirstloan -- 是否首贷
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.coorgnum, o.coorgnum) as coorgnum -- 合作机构号
    ,nvl(n.applseqnum, o.applseqnum) as applseqnum -- 申请流水号
    ,nvl(n.lrrserialno, o.lrrserialno) as lrrserialno -- 微业贷额度结果接收流水号
    ,nvl(n.intfccalltm, o.intfccalltm) as intfccalltm -- 接口调用时间
    ,nvl(n.stlprdcd, o.stlprdcd) as stlprdcd -- 核算产品代码
    ,nvl(n.ddtyp, o.ddtyp) as ddtyp -- 放款类型
    ,nvl(n.refe, o.refe) as refe -- 推荐人
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.contramt, o.contramt) as contramt -- 合同金额
    ,nvl(n.precdddate, o.precdddate) as precdddate -- 预约放款日期
    ,nvl(n.applsiteregion, o.applsiteregion) as applsiteregion -- 申请地点区划
    ,nvl(n.applusage, o.applusage) as applusage -- 申请用途
    ,nvl(n.wzguarmode, o.wzguarmode) as wzguarmode -- 微众担保方式
    ,nvl(n.dedudate, o.dedudate) as dedudate -- 扣款日
    ,nvl(n.taxpidennum, o.taxpidennum) as taxpidennum -- 纳税人识别号
    ,nvl(n.corpfname, o.corpfname) as corpfname -- 企业全称
    ,nvl(n.ptyecif, o.ptyecif) as ptyecif -- 客户CCIF
    ,nvl(n.regctyzone, o.regctyzone) as regctyzone -- 注册国家或地区
    ,nvl(n.natnregion, o.natnregion) as natnregion -- 注册地行政区划
    ,nvl(n.regloc, o.regloc) as regloc -- 注册地址
    ,nvl(n.prov, o.prov) as prov -- 省份
    ,nvl(n.orgcd, o.orgcd) as orgcd -- 组织机构代码
    ,nvl(n.csldsocicrdtid, o.csldsocicrdtid) as csldsocicrdtid -- 统一社会信用编号
    ,nvl(n.inducomregnum, o.inducomregnum) as inducomregnum -- 工商注册号
    ,nvl(n.operlicencevalidenddt, o.operlicencevalidenddt) as operlicencevalidenddt -- 营业执照有效截止日期
    ,nvl(n.gbinduclass, o.gbinduclass) as gbinduclass -- 国标行业分类
    ,nvl(n.wzcorpsize, o.wzcorpsize) as wzcorpsize -- 微众企业规模
    ,nvl(n.cbrcsmallcorpind, o.cbrcsmallcorpind) as cbrcsmallcorpind -- 银监会小企业标识
    ,nvl(n.estabdt, o.estabdt) as estabdt -- 成立日期
    ,nvl(n.operyears, o.operyears) as operyears -- 经营年限
    ,nvl(n.empcnt, o.empcnt) as empcnt -- 员工人数
    ,nvl(n.lpname, o.lpname) as lpname -- 法定代表人名称
    ,nvl(n.lpecif, o.lpecif) as lpecif -- 法人ECIF
    ,nvl(n.lpcerttyp, o.lpcerttyp) as lpcerttyp -- 法人证件类型
    ,nvl(n.lpcertnum, o.lpcertnum) as lpcertnum -- 法人证件号码
    ,nvl(n.lpcertexpidate, o.lpcertexpidate) as lpcertexpidate -- 法人证件失效日期
    ,nvl(n.lpgend, o.lpgend) as lpgend -- 法人性别
    ,nvl(n.lpethnic, o.lpethnic) as lpethnic -- 法人民族
    ,nvl(n.lpcertadr, o.lpcertadr) as lpcertadr -- 法人证件地址
    ,nvl(n.lpnation, o.lpnation) as lpnation -- 法人国籍
    ,nvl(n.lpcareer, o.lpcareer) as lpcareer -- 法人职业
    ,nvl(n.lpbirthdt, o.lpbirthdt) as lpbirthdt -- 法人出生日期
    ,nvl(n.lpcephnum, o.lpcephnum) as lpcephnum -- 法人手机号码
    ,nvl(n.certbankcardnum, o.certbankcardnum) as certbankcardnum -- 认证银行卡号
    ,nvl(n.certcephnum, o.certcephnum) as certcephnum -- 认证手机号码
    ,nvl(n.corpcitauthsigntm, o.corpcitauthsigntm) as corpcitauthsigntm -- 企业征信授权书签署时间
    ,nvl(n.indvcitauthsigntm, o.indvcitauthsigntm) as indvcitauthsigntm -- 个人征信授权书签署时间
    ,nvl(n.corpcitauthsignseq, o.corpcitauthsignseq) as corpcitauthsignseq -- 企业征信授权书签署流水号
    ,nvl(n.indvcitauthsignseq, o.indvcitauthsignseq) as indvcitauthsignseq -- 个人征信授权书签署流水号
    ,nvl(n.facecertresu, o.facecertresu) as facecertresu -- 人脸认证结果
    ,nvl(n.finalcfmlmt, o.finalcfmlmt) as finalcfmlmt -- 最终确认额度
    ,nvl(n.modelquotalmt, o.modelquotalmt) as modelquotalmt -- 模型核额额度
    ,nvl(n.coopupdalmt, o.coopupdalmt) as coopupdalmt -- 合作方修改额度
    ,nvl(n.lastchklmtdate, o.lastchklmtdate) as lastchklmtdate -- 最近核额时间
    ,nvl(n.interrat, o.interrat) as interrat -- 内部评级
    ,nvl(n.loancnt, o.loancnt) as loancnt -- 贷款笔数
    ,nvl(n.loanform, o.loanform) as loanform -- 贷款形式
    ,nvl(n.origdbillnum, o.origdbillnum) as origdbillnum -- 原借据号
    ,nvl(n.wthrguarbiz, o.wthrguarbiz) as wthrguarbiz -- 是否担保业务
    ,nvl(n.guartcompanyname, o.guartcompanyname) as guartcompanyname -- 担保公司名称
    ,nvl(n.guarcorpcerttyp, o.guarcorpcerttyp) as guarcorpcerttyp -- 担保公司证件类型
    ,nvl(n.guarcorpcertnum, o.guarcorpcertnum) as guarcorpcertnum -- 担保公司证件号码
    ,nvl(n.guarratio, o.guarratio) as guarratio -- 担保比例
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.riskresult, o.riskresult) as riskresult -- 风控结果
    ,nvl(n.isfirstloan, o.isfirstloan) as isfirstloan -- 是否首贷
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wyd_with_drawal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wyd_with_drawal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.coorgnum <> n.coorgnum
        or o.applseqnum <> n.applseqnum
        or o.lrrserialno <> n.lrrserialno
        or o.intfccalltm <> n.intfccalltm
        or o.stlprdcd <> n.stlprdcd
        or o.ddtyp <> n.ddtyp
        or o.refe <> n.refe
        or o.ccy <> n.ccy
        or o.contramt <> n.contramt
        or o.precdddate <> n.precdddate
        or o.applsiteregion <> n.applsiteregion
        or o.applusage <> n.applusage
        or o.wzguarmode <> n.wzguarmode
        or o.dedudate <> n.dedudate
        or o.taxpidennum <> n.taxpidennum
        or o.corpfname <> n.corpfname
        or o.ptyecif <> n.ptyecif
        or o.regctyzone <> n.regctyzone
        or o.natnregion <> n.natnregion
        or o.regloc <> n.regloc
        or o.prov <> n.prov
        or o.orgcd <> n.orgcd
        or o.csldsocicrdtid <> n.csldsocicrdtid
        or o.inducomregnum <> n.inducomregnum
        or o.operlicencevalidenddt <> n.operlicencevalidenddt
        or o.gbinduclass <> n.gbinduclass
        or o.wzcorpsize <> n.wzcorpsize
        or o.cbrcsmallcorpind <> n.cbrcsmallcorpind
        or o.estabdt <> n.estabdt
        or o.operyears <> n.operyears
        or o.empcnt <> n.empcnt
        or o.lpname <> n.lpname
        or o.lpecif <> n.lpecif
        or o.lpcerttyp <> n.lpcerttyp
        or o.lpcertnum <> n.lpcertnum
        or o.lpcertexpidate <> n.lpcertexpidate
        or o.lpgend <> n.lpgend
        or o.lpethnic <> n.lpethnic
        or o.lpcertadr <> n.lpcertadr
        or o.lpnation <> n.lpnation
        or o.lpcareer <> n.lpcareer
        or o.lpbirthdt <> n.lpbirthdt
        or o.lpcephnum <> n.lpcephnum
        or o.certbankcardnum <> n.certbankcardnum
        or o.certcephnum <> n.certcephnum
        or o.corpcitauthsigntm <> n.corpcitauthsigntm
        or o.indvcitauthsigntm <> n.indvcitauthsigntm
        or o.corpcitauthsignseq <> n.corpcitauthsignseq
        or o.indvcitauthsignseq <> n.indvcitauthsignseq
        or o.facecertresu <> n.facecertresu
        or o.finalcfmlmt <> n.finalcfmlmt
        or o.modelquotalmt <> n.modelquotalmt
        or o.coopupdalmt <> n.coopupdalmt
        or o.lastchklmtdate <> n.lastchklmtdate
        or o.interrat <> n.interrat
        or o.loancnt <> n.loancnt
        or o.loanform <> n.loanform
        or o.origdbillnum <> n.origdbillnum
        or o.wthrguarbiz <> n.wthrguarbiz
        or o.guartcompanyname <> n.guartcompanyname
        or o.guarcorpcerttyp <> n.guarcorpcerttyp
        or o.guarcorpcertnum <> n.guarcorpcertnum
        or o.guarratio <> n.guarratio
        or o.customerid <> n.customerid
        or o.riskresult <> n.riskresult
        or o.isfirstloan <> n.isfirstloan
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wyd_with_drawal_cl(
            serialno -- 流水号
            ,coorgnum -- 合作机构号
            ,applseqnum -- 申请流水号
            ,lrrserialno -- 微业贷额度结果接收流水号
            ,intfccalltm -- 接口调用时间
            ,stlprdcd -- 核算产品代码
            ,ddtyp -- 放款类型
            ,refe -- 推荐人
            ,ccy -- 币种
            ,contramt -- 合同金额
            ,precdddate -- 预约放款日期
            ,applsiteregion -- 申请地点区划
            ,applusage -- 申请用途
            ,wzguarmode -- 微众担保方式
            ,dedudate -- 扣款日
            ,taxpidennum -- 纳税人识别号
            ,corpfname -- 企业全称
            ,ptyecif -- 客户CCIF
            ,regctyzone -- 注册国家或地区
            ,natnregion -- 注册地行政区划
            ,regloc -- 注册地址
            ,prov -- 省份
            ,orgcd -- 组织机构代码
            ,csldsocicrdtid -- 统一社会信用编号
            ,inducomregnum -- 工商注册号
            ,operlicencevalidenddt -- 营业执照有效截止日期
            ,gbinduclass -- 国标行业分类
            ,wzcorpsize -- 微众企业规模
            ,cbrcsmallcorpind -- 银监会小企业标识
            ,estabdt -- 成立日期
            ,operyears -- 经营年限
            ,empcnt -- 员工人数
            ,lpname -- 法定代表人名称
            ,lpecif -- 法人ECIF
            ,lpcerttyp -- 法人证件类型
            ,lpcertnum -- 法人证件号码
            ,lpcertexpidate -- 法人证件失效日期
            ,lpgend -- 法人性别
            ,lpethnic -- 法人民族
            ,lpcertadr -- 法人证件地址
            ,lpnation -- 法人国籍
            ,lpcareer -- 法人职业
            ,lpbirthdt -- 法人出生日期
            ,lpcephnum -- 法人手机号码
            ,certbankcardnum -- 认证银行卡号
            ,certcephnum -- 认证手机号码
            ,corpcitauthsigntm -- 企业征信授权书签署时间
            ,indvcitauthsigntm -- 个人征信授权书签署时间
            ,corpcitauthsignseq -- 企业征信授权书签署流水号
            ,indvcitauthsignseq -- 个人征信授权书签署流水号
            ,facecertresu -- 人脸认证结果
            ,finalcfmlmt -- 最终确认额度
            ,modelquotalmt -- 模型核额额度
            ,coopupdalmt -- 合作方修改额度
            ,lastchklmtdate -- 最近核额时间
            ,interrat -- 内部评级
            ,loancnt -- 贷款笔数
            ,loanform -- 贷款形式
            ,origdbillnum -- 原借据号
            ,wthrguarbiz -- 是否担保业务
            ,guartcompanyname -- 担保公司名称
            ,guarcorpcerttyp -- 担保公司证件类型
            ,guarcorpcertnum -- 担保公司证件号码
            ,guarratio -- 担保比例
            ,customerid -- 客户编号
            ,riskresult -- 风控结果
            ,isfirstloan -- 是否首贷
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wyd_with_drawal_op(
            serialno -- 流水号
            ,coorgnum -- 合作机构号
            ,applseqnum -- 申请流水号
            ,lrrserialno -- 微业贷额度结果接收流水号
            ,intfccalltm -- 接口调用时间
            ,stlprdcd -- 核算产品代码
            ,ddtyp -- 放款类型
            ,refe -- 推荐人
            ,ccy -- 币种
            ,contramt -- 合同金额
            ,precdddate -- 预约放款日期
            ,applsiteregion -- 申请地点区划
            ,applusage -- 申请用途
            ,wzguarmode -- 微众担保方式
            ,dedudate -- 扣款日
            ,taxpidennum -- 纳税人识别号
            ,corpfname -- 企业全称
            ,ptyecif -- 客户CCIF
            ,regctyzone -- 注册国家或地区
            ,natnregion -- 注册地行政区划
            ,regloc -- 注册地址
            ,prov -- 省份
            ,orgcd -- 组织机构代码
            ,csldsocicrdtid -- 统一社会信用编号
            ,inducomregnum -- 工商注册号
            ,operlicencevalidenddt -- 营业执照有效截止日期
            ,gbinduclass -- 国标行业分类
            ,wzcorpsize -- 微众企业规模
            ,cbrcsmallcorpind -- 银监会小企业标识
            ,estabdt -- 成立日期
            ,operyears -- 经营年限
            ,empcnt -- 员工人数
            ,lpname -- 法定代表人名称
            ,lpecif -- 法人ECIF
            ,lpcerttyp -- 法人证件类型
            ,lpcertnum -- 法人证件号码
            ,lpcertexpidate -- 法人证件失效日期
            ,lpgend -- 法人性别
            ,lpethnic -- 法人民族
            ,lpcertadr -- 法人证件地址
            ,lpnation -- 法人国籍
            ,lpcareer -- 法人职业
            ,lpbirthdt -- 法人出生日期
            ,lpcephnum -- 法人手机号码
            ,certbankcardnum -- 认证银行卡号
            ,certcephnum -- 认证手机号码
            ,corpcitauthsigntm -- 企业征信授权书签署时间
            ,indvcitauthsigntm -- 个人征信授权书签署时间
            ,corpcitauthsignseq -- 企业征信授权书签署流水号
            ,indvcitauthsignseq -- 个人征信授权书签署流水号
            ,facecertresu -- 人脸认证结果
            ,finalcfmlmt -- 最终确认额度
            ,modelquotalmt -- 模型核额额度
            ,coopupdalmt -- 合作方修改额度
            ,lastchklmtdate -- 最近核额时间
            ,interrat -- 内部评级
            ,loancnt -- 贷款笔数
            ,loanform -- 贷款形式
            ,origdbillnum -- 原借据号
            ,wthrguarbiz -- 是否担保业务
            ,guartcompanyname -- 担保公司名称
            ,guarcorpcerttyp -- 担保公司证件类型
            ,guarcorpcertnum -- 担保公司证件号码
            ,guarratio -- 担保比例
            ,customerid -- 客户编号
            ,riskresult -- 风控结果
            ,isfirstloan -- 是否首贷
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.coorgnum -- 合作机构号
    ,o.applseqnum -- 申请流水号
    ,o.lrrserialno -- 微业贷额度结果接收流水号
    ,o.intfccalltm -- 接口调用时间
    ,o.stlprdcd -- 核算产品代码
    ,o.ddtyp -- 放款类型
    ,o.refe -- 推荐人
    ,o.ccy -- 币种
    ,o.contramt -- 合同金额
    ,o.precdddate -- 预约放款日期
    ,o.applsiteregion -- 申请地点区划
    ,o.applusage -- 申请用途
    ,o.wzguarmode -- 微众担保方式
    ,o.dedudate -- 扣款日
    ,o.taxpidennum -- 纳税人识别号
    ,o.corpfname -- 企业全称
    ,o.ptyecif -- 客户CCIF
    ,o.regctyzone -- 注册国家或地区
    ,o.natnregion -- 注册地行政区划
    ,o.regloc -- 注册地址
    ,o.prov -- 省份
    ,o.orgcd -- 组织机构代码
    ,o.csldsocicrdtid -- 统一社会信用编号
    ,o.inducomregnum -- 工商注册号
    ,o.operlicencevalidenddt -- 营业执照有效截止日期
    ,o.gbinduclass -- 国标行业分类
    ,o.wzcorpsize -- 微众企业规模
    ,o.cbrcsmallcorpind -- 银监会小企业标识
    ,o.estabdt -- 成立日期
    ,o.operyears -- 经营年限
    ,o.empcnt -- 员工人数
    ,o.lpname -- 法定代表人名称
    ,o.lpecif -- 法人ECIF
    ,o.lpcerttyp -- 法人证件类型
    ,o.lpcertnum -- 法人证件号码
    ,o.lpcertexpidate -- 法人证件失效日期
    ,o.lpgend -- 法人性别
    ,o.lpethnic -- 法人民族
    ,o.lpcertadr -- 法人证件地址
    ,o.lpnation -- 法人国籍
    ,o.lpcareer -- 法人职业
    ,o.lpbirthdt -- 法人出生日期
    ,o.lpcephnum -- 法人手机号码
    ,o.certbankcardnum -- 认证银行卡号
    ,o.certcephnum -- 认证手机号码
    ,o.corpcitauthsigntm -- 企业征信授权书签署时间
    ,o.indvcitauthsigntm -- 个人征信授权书签署时间
    ,o.corpcitauthsignseq -- 企业征信授权书签署流水号
    ,o.indvcitauthsignseq -- 个人征信授权书签署流水号
    ,o.facecertresu -- 人脸认证结果
    ,o.finalcfmlmt -- 最终确认额度
    ,o.modelquotalmt -- 模型核额额度
    ,o.coopupdalmt -- 合作方修改额度
    ,o.lastchklmtdate -- 最近核额时间
    ,o.interrat -- 内部评级
    ,o.loancnt -- 贷款笔数
    ,o.loanform -- 贷款形式
    ,o.origdbillnum -- 原借据号
    ,o.wthrguarbiz -- 是否担保业务
    ,o.guartcompanyname -- 担保公司名称
    ,o.guarcorpcerttyp -- 担保公司证件类型
    ,o.guarcorpcertnum -- 担保公司证件号码
    ,o.guarratio -- 担保比例
    ,o.customerid -- 客户编号
    ,o.riskresult -- 风控结果
    ,o.isfirstloan -- 是否首贷
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
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
from ${iol_schema}.icms_wyd_with_drawal_bk o
    left join ${iol_schema}.icms_wyd_with_drawal_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wyd_with_drawal_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wyd_with_drawal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wyd_with_drawal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wyd_with_drawal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wyd_with_drawal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wyd_with_drawal exchange partition p_${batch_date} with table ${iol_schema}.icms_wyd_with_drawal_cl;
alter table ${iol_schema}.icms_wyd_with_drawal exchange partition p_20991231 with table ${iol_schema}.icms_wyd_with_drawal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wyd_with_drawal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wyd_with_drawal_op purge;
drop table ${iol_schema}.icms_wyd_with_drawal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wyd_with_drawal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wyd_with_drawal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);

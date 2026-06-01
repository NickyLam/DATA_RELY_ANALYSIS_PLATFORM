/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_interf_payhsrcsecinfo
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
create table ${iol_schema}.fams_interf_payhsrcsecinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_interf_payhsrcsecinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_interf_payhsrcsecinfo_op purge;
drop table ${iol_schema}.fams_interf_payhsrcsecinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_interf_payhsrcsecinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_interf_payhsrcsecinfo where 0=1;

create table ${iol_schema}.fams_interf_payhsrcsecinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_interf_payhsrcsecinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_interf_payhsrcsecinfo_cl(
            secid -- 债券id：xxxx.ib/xxxx.sz
            ,secname -- 债券简称
            ,seccode -- 债券code
            ,market -- 市场
            ,secfullname -- 债券全称
            ,ratebasic -- 计息基准：参考右边明细
            ,couponspecies -- 息票品种 npv付息 dis贴现 iam利随本清 zco零息
            ,interestrate -- 利率类型 fi固定，fl浮动
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,paycycle -- 付息频率
            ,facevalue -- 面额 默认100
            ,issueprice -- 发行价
            ,paperir -- 票面利率
            ,schecalrule -- 付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则 p向前调整 s向后调整 m调整的向后 n不调整
            ,issuershort -- 发行人
            ,resettype -- 利率调整规则
            ,observebefday -- 延后时间
            ,observebefunit -- 延后时间单位
            ,toprate -- 利率上限
            ,bottomrate -- 利率下限
            ,issueamt -- 发行总额
            ,ratecode -- 浮动利率code
            ,spreadrate_8 -- 浮动利差
            ,coefficient -- 浮动系数
            ,sectype -- 系统债券类型：
            ,sectype2 -- 系统债券类型：
            ,chbsectype -- 中债债券类型：
            ,chbsectype2 -- 中债债券类型：
            ,pbocsectype -- 人行债券类型：
            ,pbocsectype2 -- 人行债券类型：
            ,remark -- 备注
            ,issecbond -- 是否次级债,y是n否
            ,issus -- 是否永续债,y是n否
            ,calloption -- 是否可赎回,y是n否
            ,putoption -- 是否可回售,y是n否
            ,institution -- 登记托管机构
            ,institutiontext -- 登记托管机构说明
            ,markettext -- 交易场所说明
            ,market2 -- 交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它
            ,ccy -- 币种 cny 人民币、hkd 港币、jpy 日元、usd 美元
            ,issuetype -- 发行方式
            ,blnarea -- 境内外
            ,guarantor -- 担保人
            ,guartype -- 担保方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,source -- 数据来源
            ,pubenddate -- 发行截止日
            ,asset_class -- 资产/负债类别
            ,concrete_class -- 具体类别
            ,concrete_class_sm -- 具体类别说明
            ,issuer_scale_type -- 发行机构类型（按规模划分）
            ,issuer_technology_type -- 发行机构类型（按技术领域划分）
            ,issuer_economic_type -- 发行机构类型（按经济领域划分）
            ,issuer_desc -- 发行机构类型说明
            ,issuer_institutions -- 发行机构所属行业
            ,city_invest_sec_chb -- 是否城投债（中债）
            ,city_invest_sec_provinces -- 城投债省及省会（单列市）
            ,city_invest_sec_cities -- 城投债地级市
            ,city_invest_sec_county -- 城投债县及县级市
            ,city_invest_sec_wind -- 是否城投债（wind）
            ,city_invest_sec_cbrc -- 是否城投债（银监）
            ,issuer_institutions_second -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_interf_payhsrcsecinfo_op(
            secid -- 债券id：xxxx.ib/xxxx.sz
            ,secname -- 债券简称
            ,seccode -- 债券code
            ,market -- 市场
            ,secfullname -- 债券全称
            ,ratebasic -- 计息基准：参考右边明细
            ,couponspecies -- 息票品种 npv付息 dis贴现 iam利随本清 zco零息
            ,interestrate -- 利率类型 fi固定，fl浮动
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,paycycle -- 付息频率
            ,facevalue -- 面额 默认100
            ,issueprice -- 发行价
            ,paperir -- 票面利率
            ,schecalrule -- 付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则 p向前调整 s向后调整 m调整的向后 n不调整
            ,issuershort -- 发行人
            ,resettype -- 利率调整规则
            ,observebefday -- 延后时间
            ,observebefunit -- 延后时间单位
            ,toprate -- 利率上限
            ,bottomrate -- 利率下限
            ,issueamt -- 发行总额
            ,ratecode -- 浮动利率code
            ,spreadrate_8 -- 浮动利差
            ,coefficient -- 浮动系数
            ,sectype -- 系统债券类型：
            ,sectype2 -- 系统债券类型：
            ,chbsectype -- 中债债券类型：
            ,chbsectype2 -- 中债债券类型：
            ,pbocsectype -- 人行债券类型：
            ,pbocsectype2 -- 人行债券类型：
            ,remark -- 备注
            ,issecbond -- 是否次级债,y是n否
            ,issus -- 是否永续债,y是n否
            ,calloption -- 是否可赎回,y是n否
            ,putoption -- 是否可回售,y是n否
            ,institution -- 登记托管机构
            ,institutiontext -- 登记托管机构说明
            ,markettext -- 交易场所说明
            ,market2 -- 交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它
            ,ccy -- 币种 cny 人民币、hkd 港币、jpy 日元、usd 美元
            ,issuetype -- 发行方式
            ,blnarea -- 境内外
            ,guarantor -- 担保人
            ,guartype -- 担保方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,source -- 数据来源
            ,pubenddate -- 发行截止日
            ,asset_class -- 资产/负债类别
            ,concrete_class -- 具体类别
            ,concrete_class_sm -- 具体类别说明
            ,issuer_scale_type -- 发行机构类型（按规模划分）
            ,issuer_technology_type -- 发行机构类型（按技术领域划分）
            ,issuer_economic_type -- 发行机构类型（按经济领域划分）
            ,issuer_desc -- 发行机构类型说明
            ,issuer_institutions -- 发行机构所属行业
            ,city_invest_sec_chb -- 是否城投债（中债）
            ,city_invest_sec_provinces -- 城投债省及省会（单列市）
            ,city_invest_sec_cities -- 城投债地级市
            ,city_invest_sec_county -- 城投债县及县级市
            ,city_invest_sec_wind -- 是否城投债（wind）
            ,city_invest_sec_cbrc -- 是否城投债（银监）
            ,issuer_institutions_second -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.secid, o.secid) as secid -- 债券id：xxxx.ib/xxxx.sz
    ,nvl(n.secname, o.secname) as secname -- 债券简称
    ,nvl(n.seccode, o.seccode) as seccode -- 债券code
    ,nvl(n.market, o.market) as market -- 市场
    ,nvl(n.secfullname, o.secfullname) as secfullname -- 债券全称
    ,nvl(n.ratebasic, o.ratebasic) as ratebasic -- 计息基准：参考右边明细
    ,nvl(n.couponspecies, o.couponspecies) as couponspecies -- 息票品种 npv付息 dis贴现 iam利随本清 zco零息
    ,nvl(n.interestrate, o.interestrate) as interestrate -- 利率类型 fi固定，fl浮动
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.paycycle, o.paycycle) as paycycle -- 付息频率
    ,nvl(n.facevalue, o.facevalue) as facevalue -- 面额 默认100
    ,nvl(n.issueprice, o.issueprice) as issueprice -- 发行价
    ,nvl(n.paperir, o.paperir) as paperir -- 票面利率
    ,nvl(n.schecalrule, o.schecalrule) as schecalrule -- 付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日
    ,nvl(n.firstrateday, o.firstrateday) as firstrateday -- 首次付息日
    ,nvl(n.workdayrule, o.workdayrule) as workdayrule -- 营业日准则 p向前调整 s向后调整 m调整的向后 n不调整
    ,nvl(n.issuershort, o.issuershort) as issuershort -- 发行人
    ,nvl(n.resettype, o.resettype) as resettype -- 利率调整规则
    ,nvl(n.observebefday, o.observebefday) as observebefday -- 延后时间
    ,nvl(n.observebefunit, o.observebefunit) as observebefunit -- 延后时间单位
    ,nvl(n.toprate, o.toprate) as toprate -- 利率上限
    ,nvl(n.bottomrate, o.bottomrate) as bottomrate -- 利率下限
    ,nvl(n.issueamt, o.issueamt) as issueamt -- 发行总额
    ,nvl(n.ratecode, o.ratecode) as ratecode -- 浮动利率code
    ,nvl(n.spreadrate_8, o.spreadrate_8) as spreadrate_8 -- 浮动利差
    ,nvl(n.coefficient, o.coefficient) as coefficient -- 浮动系数
    ,nvl(n.sectype, o.sectype) as sectype -- 系统债券类型：
    ,nvl(n.sectype2, o.sectype2) as sectype2 -- 系统债券类型：
    ,nvl(n.chbsectype, o.chbsectype) as chbsectype -- 中债债券类型：
    ,nvl(n.chbsectype2, o.chbsectype2) as chbsectype2 -- 中债债券类型：
    ,nvl(n.pbocsectype, o.pbocsectype) as pbocsectype -- 人行债券类型：
    ,nvl(n.pbocsectype2, o.pbocsectype2) as pbocsectype2 -- 人行债券类型：
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.issecbond, o.issecbond) as issecbond -- 是否次级债,y是n否
    ,nvl(n.issus, o.issus) as issus -- 是否永续债,y是n否
    ,nvl(n.calloption, o.calloption) as calloption -- 是否可赎回,y是n否
    ,nvl(n.putoption, o.putoption) as putoption -- 是否可回售,y是n否
    ,nvl(n.institution, o.institution) as institution -- 登记托管机构
    ,nvl(n.institutiontext, o.institutiontext) as institutiontext -- 登记托管机构说明
    ,nvl(n.markettext, o.markettext) as markettext -- 交易场所说明
    ,nvl(n.market2, o.market2) as market2 -- 交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它
    ,nvl(n.ccy, o.ccy) as ccy -- 币种 cny 人民币、hkd 港币、jpy 日元、usd 美元
    ,nvl(n.issuetype, o.issuetype) as issuetype -- 发行方式
    ,nvl(n.blnarea, o.blnarea) as blnarea -- 境内外
    ,nvl(n.guarantor, o.guarantor) as guarantor -- 担保人
    ,nvl(n.guartype, o.guartype) as guartype -- 担保方式
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.source, o.source) as source -- 数据来源
    ,nvl(n.pubenddate, o.pubenddate) as pubenddate -- 发行截止日
    ,nvl(n.asset_class, o.asset_class) as asset_class -- 资产/负债类别
    ,nvl(n.concrete_class, o.concrete_class) as concrete_class -- 具体类别
    ,nvl(n.concrete_class_sm, o.concrete_class_sm) as concrete_class_sm -- 具体类别说明
    ,nvl(n.issuer_scale_type, o.issuer_scale_type) as issuer_scale_type -- 发行机构类型（按规模划分）
    ,nvl(n.issuer_technology_type, o.issuer_technology_type) as issuer_technology_type -- 发行机构类型（按技术领域划分）
    ,nvl(n.issuer_economic_type, o.issuer_economic_type) as issuer_economic_type -- 发行机构类型（按经济领域划分）
    ,nvl(n.issuer_desc, o.issuer_desc) as issuer_desc -- 发行机构类型说明
    ,nvl(n.issuer_institutions, o.issuer_institutions) as issuer_institutions -- 发行机构所属行业
    ,nvl(n.city_invest_sec_chb, o.city_invest_sec_chb) as city_invest_sec_chb -- 是否城投债（中债）
    ,nvl(n.city_invest_sec_provinces, o.city_invest_sec_provinces) as city_invest_sec_provinces -- 城投债省及省会（单列市）
    ,nvl(n.city_invest_sec_cities, o.city_invest_sec_cities) as city_invest_sec_cities -- 城投债地级市
    ,nvl(n.city_invest_sec_county, o.city_invest_sec_county) as city_invest_sec_county -- 城投债县及县级市
    ,nvl(n.city_invest_sec_wind, o.city_invest_sec_wind) as city_invest_sec_wind -- 是否城投债（wind）
    ,nvl(n.city_invest_sec_cbrc, o.city_invest_sec_cbrc) as city_invest_sec_cbrc -- 是否城投债（银监）
    ,nvl(n.issuer_institutions_second, o.issuer_institutions_second) as issuer_institutions_second -- 
    ,case when
            n.secid is null
            and n.source is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.secid is null
            and n.source is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.secid is null
            and n.source is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_interf_payhsrcsecinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_interf_payhsrcsecinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.secid = n.secid
            and o.source = n.source
where (
        o.secid is null
        and o.source is null
    )
    or (
        n.secid is null
        and n.source is null
    )
    or (
        o.secname <> n.secname
        or o.seccode <> n.seccode
        or o.market <> n.market
        or o.secfullname <> n.secfullname
        or o.ratebasic <> n.ratebasic
        or o.couponspecies <> n.couponspecies
        or o.interestrate <> n.interestrate
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.paycycle <> n.paycycle
        or o.facevalue <> n.facevalue
        or o.issueprice <> n.issueprice
        or o.paperir <> n.paperir
        or o.schecalrule <> n.schecalrule
        or o.firstrateday <> n.firstrateday
        or o.workdayrule <> n.workdayrule
        or o.issuershort <> n.issuershort
        or o.resettype <> n.resettype
        or o.observebefday <> n.observebefday
        or o.observebefunit <> n.observebefunit
        or o.toprate <> n.toprate
        or o.bottomrate <> n.bottomrate
        or o.issueamt <> n.issueamt
        or o.ratecode <> n.ratecode
        or o.spreadrate_8 <> n.spreadrate_8
        or o.coefficient <> n.coefficient
        or o.sectype <> n.sectype
        or o.sectype2 <> n.sectype2
        or o.chbsectype <> n.chbsectype
        or o.chbsectype2 <> n.chbsectype2
        or o.pbocsectype <> n.pbocsectype
        or o.pbocsectype2 <> n.pbocsectype2
        or o.remark <> n.remark
        or o.issecbond <> n.issecbond
        or o.issus <> n.issus
        or o.calloption <> n.calloption
        or o.putoption <> n.putoption
        or o.institution <> n.institution
        or o.institutiontext <> n.institutiontext
        or o.markettext <> n.markettext
        or o.market2 <> n.market2
        or o.ccy <> n.ccy
        or o.issuetype <> n.issuetype
        or o.blnarea <> n.blnarea
        or o.guarantor <> n.guarantor
        or o.guartype <> n.guartype
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.pubenddate <> n.pubenddate
        or o.asset_class <> n.asset_class
        or o.concrete_class <> n.concrete_class
        or o.concrete_class_sm <> n.concrete_class_sm
        or o.issuer_scale_type <> n.issuer_scale_type
        or o.issuer_technology_type <> n.issuer_technology_type
        or o.issuer_economic_type <> n.issuer_economic_type
        or o.issuer_desc <> n.issuer_desc
        or o.issuer_institutions <> n.issuer_institutions
        or o.city_invest_sec_chb <> n.city_invest_sec_chb
        or o.city_invest_sec_provinces <> n.city_invest_sec_provinces
        or o.city_invest_sec_cities <> n.city_invest_sec_cities
        or o.city_invest_sec_county <> n.city_invest_sec_county
        or o.city_invest_sec_wind <> n.city_invest_sec_wind
        or o.city_invest_sec_cbrc <> n.city_invest_sec_cbrc
        or o.issuer_institutions_second <> n.issuer_institutions_second
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_interf_payhsrcsecinfo_cl(
            secid -- 债券id：xxxx.ib/xxxx.sz
            ,secname -- 债券简称
            ,seccode -- 债券code
            ,market -- 市场
            ,secfullname -- 债券全称
            ,ratebasic -- 计息基准：参考右边明细
            ,couponspecies -- 息票品种 npv付息 dis贴现 iam利随本清 zco零息
            ,interestrate -- 利率类型 fi固定，fl浮动
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,paycycle -- 付息频率
            ,facevalue -- 面额 默认100
            ,issueprice -- 发行价
            ,paperir -- 票面利率
            ,schecalrule -- 付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则 p向前调整 s向后调整 m调整的向后 n不调整
            ,issuershort -- 发行人
            ,resettype -- 利率调整规则
            ,observebefday -- 延后时间
            ,observebefunit -- 延后时间单位
            ,toprate -- 利率上限
            ,bottomrate -- 利率下限
            ,issueamt -- 发行总额
            ,ratecode -- 浮动利率code
            ,spreadrate_8 -- 浮动利差
            ,coefficient -- 浮动系数
            ,sectype -- 系统债券类型：
            ,sectype2 -- 系统债券类型：
            ,chbsectype -- 中债债券类型：
            ,chbsectype2 -- 中债债券类型：
            ,pbocsectype -- 人行债券类型：
            ,pbocsectype2 -- 人行债券类型：
            ,remark -- 备注
            ,issecbond -- 是否次级债,y是n否
            ,issus -- 是否永续债,y是n否
            ,calloption -- 是否可赎回,y是n否
            ,putoption -- 是否可回售,y是n否
            ,institution -- 登记托管机构
            ,institutiontext -- 登记托管机构说明
            ,markettext -- 交易场所说明
            ,market2 -- 交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它
            ,ccy -- 币种 cny 人民币、hkd 港币、jpy 日元、usd 美元
            ,issuetype -- 发行方式
            ,blnarea -- 境内外
            ,guarantor -- 担保人
            ,guartype -- 担保方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,source -- 数据来源
            ,pubenddate -- 发行截止日
            ,asset_class -- 资产/负债类别
            ,concrete_class -- 具体类别
            ,concrete_class_sm -- 具体类别说明
            ,issuer_scale_type -- 发行机构类型（按规模划分）
            ,issuer_technology_type -- 发行机构类型（按技术领域划分）
            ,issuer_economic_type -- 发行机构类型（按经济领域划分）
            ,issuer_desc -- 发行机构类型说明
            ,issuer_institutions -- 发行机构所属行业
            ,city_invest_sec_chb -- 是否城投债（中债）
            ,city_invest_sec_provinces -- 城投债省及省会（单列市）
            ,city_invest_sec_cities -- 城投债地级市
            ,city_invest_sec_county -- 城投债县及县级市
            ,city_invest_sec_wind -- 是否城投债（wind）
            ,city_invest_sec_cbrc -- 是否城投债（银监）
            ,issuer_institutions_second -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_interf_payhsrcsecinfo_op(
            secid -- 债券id：xxxx.ib/xxxx.sz
            ,secname -- 债券简称
            ,seccode -- 债券code
            ,market -- 市场
            ,secfullname -- 债券全称
            ,ratebasic -- 计息基准：参考右边明细
            ,couponspecies -- 息票品种 npv付息 dis贴现 iam利随本清 zco零息
            ,interestrate -- 利率类型 fi固定，fl浮动
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,paycycle -- 付息频率
            ,facevalue -- 面额 默认100
            ,issueprice -- 发行价
            ,paperir -- 票面利率
            ,schecalrule -- 付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日
            ,firstrateday -- 首次付息日
            ,workdayrule -- 营业日准则 p向前调整 s向后调整 m调整的向后 n不调整
            ,issuershort -- 发行人
            ,resettype -- 利率调整规则
            ,observebefday -- 延后时间
            ,observebefunit -- 延后时间单位
            ,toprate -- 利率上限
            ,bottomrate -- 利率下限
            ,issueamt -- 发行总额
            ,ratecode -- 浮动利率code
            ,spreadrate_8 -- 浮动利差
            ,coefficient -- 浮动系数
            ,sectype -- 系统债券类型：
            ,sectype2 -- 系统债券类型：
            ,chbsectype -- 中债债券类型：
            ,chbsectype2 -- 中债债券类型：
            ,pbocsectype -- 人行债券类型：
            ,pbocsectype2 -- 人行债券类型：
            ,remark -- 备注
            ,issecbond -- 是否次级债,y是n否
            ,issus -- 是否永续债,y是n否
            ,calloption -- 是否可赎回,y是n否
            ,putoption -- 是否可回售,y是n否
            ,institution -- 登记托管机构
            ,institutiontext -- 登记托管机构说明
            ,markettext -- 交易场所说明
            ,market2 -- 交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它
            ,ccy -- 币种 cny 人民币、hkd 港币、jpy 日元、usd 美元
            ,issuetype -- 发行方式
            ,blnarea -- 境内外
            ,guarantor -- 担保人
            ,guartype -- 担保方式
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,source -- 数据来源
            ,pubenddate -- 发行截止日
            ,asset_class -- 资产/负债类别
            ,concrete_class -- 具体类别
            ,concrete_class_sm -- 具体类别说明
            ,issuer_scale_type -- 发行机构类型（按规模划分）
            ,issuer_technology_type -- 发行机构类型（按技术领域划分）
            ,issuer_economic_type -- 发行机构类型（按经济领域划分）
            ,issuer_desc -- 发行机构类型说明
            ,issuer_institutions -- 发行机构所属行业
            ,city_invest_sec_chb -- 是否城投债（中债）
            ,city_invest_sec_provinces -- 城投债省及省会（单列市）
            ,city_invest_sec_cities -- 城投债地级市
            ,city_invest_sec_county -- 城投债县及县级市
            ,city_invest_sec_wind -- 是否城投债（wind）
            ,city_invest_sec_cbrc -- 是否城投债（银监）
            ,issuer_institutions_second -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.secid -- 债券id：xxxx.ib/xxxx.sz
    ,o.secname -- 债券简称
    ,o.seccode -- 债券code
    ,o.market -- 市场
    ,o.secfullname -- 债券全称
    ,o.ratebasic -- 计息基准：参考右边明细
    ,o.couponspecies -- 息票品种 npv付息 dis贴现 iam利随本清 zco零息
    ,o.interestrate -- 利率类型 fi固定，fl浮动
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.paycycle -- 付息频率
    ,o.facevalue -- 面额 默认100
    ,o.issueprice -- 发行价
    ,o.paperir -- 票面利率
    ,o.schecalrule -- 付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日
    ,o.firstrateday -- 首次付息日
    ,o.workdayrule -- 营业日准则 p向前调整 s向后调整 m调整的向后 n不调整
    ,o.issuershort -- 发行人
    ,o.resettype -- 利率调整规则
    ,o.observebefday -- 延后时间
    ,o.observebefunit -- 延后时间单位
    ,o.toprate -- 利率上限
    ,o.bottomrate -- 利率下限
    ,o.issueamt -- 发行总额
    ,o.ratecode -- 浮动利率code
    ,o.spreadrate_8 -- 浮动利差
    ,o.coefficient -- 浮动系数
    ,o.sectype -- 系统债券类型：
    ,o.sectype2 -- 系统债券类型：
    ,o.chbsectype -- 中债债券类型：
    ,o.chbsectype2 -- 中债债券类型：
    ,o.pbocsectype -- 人行债券类型：
    ,o.pbocsectype2 -- 人行债券类型：
    ,o.remark -- 备注
    ,o.issecbond -- 是否次级债,y是n否
    ,o.issus -- 是否永续债,y是n否
    ,o.calloption -- 是否可赎回,y是n否
    ,o.putoption -- 是否可回售,y是n否
    ,o.institution -- 登记托管机构
    ,o.institutiontext -- 登记托管机构说明
    ,o.markettext -- 交易场所说明
    ,o.market2 -- 交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它
    ,o.ccy -- 币种 cny 人民币、hkd 港币、jpy 日元、usd 美元
    ,o.issuetype -- 发行方式
    ,o.blnarea -- 境内外
    ,o.guarantor -- 担保人
    ,o.guartype -- 担保方式
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.source -- 数据来源
    ,o.pubenddate -- 发行截止日
    ,o.asset_class -- 资产/负债类别
    ,o.concrete_class -- 具体类别
    ,o.concrete_class_sm -- 具体类别说明
    ,o.issuer_scale_type -- 发行机构类型（按规模划分）
    ,o.issuer_technology_type -- 发行机构类型（按技术领域划分）
    ,o.issuer_economic_type -- 发行机构类型（按经济领域划分）
    ,o.issuer_desc -- 发行机构类型说明
    ,o.issuer_institutions -- 发行机构所属行业
    ,o.city_invest_sec_chb -- 是否城投债（中债）
    ,o.city_invest_sec_provinces -- 城投债省及省会（单列市）
    ,o.city_invest_sec_cities -- 城投债地级市
    ,o.city_invest_sec_county -- 城投债县及县级市
    ,o.city_invest_sec_wind -- 是否城投债（wind）
    ,o.city_invest_sec_cbrc -- 是否城投债（银监）
    ,o.issuer_institutions_second -- 
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
from ${iol_schema}.fams_interf_payhsrcsecinfo_bk o
    left join ${iol_schema}.fams_interf_payhsrcsecinfo_op n
        on
            o.secid = n.secid
            and o.source = n.source
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_interf_payhsrcsecinfo_cl d
        on
            o.secid = d.secid
            and o.source = d.source
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_interf_payhsrcsecinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_interf_payhsrcsecinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_interf_payhsrcsecinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_interf_payhsrcsecinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_interf_payhsrcsecinfo exchange partition p_${batch_date} with table ${iol_schema}.fams_interf_payhsrcsecinfo_cl;
alter table ${iol_schema}.fams_interf_payhsrcsecinfo exchange partition p_20991231 with table ${iol_schema}.fams_interf_payhsrcsecinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_interf_payhsrcsecinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_interf_payhsrcsecinfo_op purge;
drop table ${iol_schema}.fams_interf_payhsrcsecinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_interf_payhsrcsecinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_interf_payhsrcsecinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);

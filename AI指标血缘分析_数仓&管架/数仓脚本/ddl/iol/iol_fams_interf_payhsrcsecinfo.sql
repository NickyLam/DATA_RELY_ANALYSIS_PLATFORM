/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_interf_payhsrcsecinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_interf_payhsrcsecinfo
whenever sqlerror continue none;
drop table ${iol_schema}.fams_interf_payhsrcsecinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_interf_payhsrcsecinfo(
    secid varchar2(50) -- 债券id：xxxx.ib/xxxx.sz
    ,secname varchar2(200) -- 债券简称
    ,seccode varchar2(50) -- 债券code
    ,market varchar2(2) -- 市场
    ,secfullname varchar2(500) -- 债券全称
    ,ratebasic varchar2(10) -- 计息基准：参考右边明细
    ,couponspecies varchar2(3) -- 息票品种 npv付息 dis贴现 iam利随本清 zco零息
    ,interestrate varchar2(2) -- 利率类型 fi固定，fl浮动
    ,vdate date -- 起息日
    ,mdate date -- 到期日
    ,paycycle varchar2(50) -- 付息频率
    ,facevalue number(20,4) -- 面额 默认100
    ,issueprice number(20,4) -- 发行价
    ,paperir number(18,12) -- 票面利率
    ,schecalrule varchar2(2) -- 付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日
    ,firstrateday date -- 首次付息日
    ,workdayrule varchar2(2) -- 营业日准则 p向前调整 s向后调整 m调整的向后 n不调整
    ,issuershort varchar2(50) -- 发行人
    ,resettype varchar2(50) -- 利率调整规则
    ,observebefday number(10) -- 延后时间
    ,observebefunit varchar2(50) -- 延后时间单位
    ,toprate number(20,14) -- 利率上限
    ,bottomrate number(20,14) -- 利率下限
    ,issueamt number(20,4) -- 发行总额
    ,ratecode varchar2(50) -- 浮动利率code
    ,spreadrate_8 number(20,14) -- 浮动利差
    ,coefficient number(18,12) -- 浮动系数
    ,sectype varchar2(50) -- 系统债券类型：
    ,sectype2 varchar2(50) -- 系统债券类型：
    ,chbsectype varchar2(50) -- 中债债券类型：
    ,chbsectype2 varchar2(50) -- 中债债券类型：
    ,pbocsectype varchar2(50) -- 人行债券类型：
    ,pbocsectype2 varchar2(50) -- 人行债券类型：
    ,remark nvarchar2(510) -- 备注
    ,issecbond varchar2(50) -- 是否次级债,y是n否
    ,issus varchar2(50) -- 是否永续债,y是n否
    ,calloption varchar2(50) -- 是否可赎回,y是n否
    ,putoption varchar2(50) -- 是否可回售,y是n否
    ,institution varchar2(100) -- 登记托管机构
    ,institutiontext nvarchar2(800) -- 登记托管机构说明
    ,markettext nvarchar2(800) -- 交易场所说明
    ,market2 varchar2(2) -- 交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它
    ,ccy varchar2(3) -- 币种 cny 人民币、hkd 港币、jpy 日元、usd 美元
    ,issuetype varchar2(50) -- 发行方式
    ,blnarea varchar2(50) -- 境内外
    ,guarantor varchar2(400) -- 担保人
    ,guartype varchar2(100) -- 担保方式
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,source varchar2(50) -- 数据来源
    ,pubenddate date -- 发行截止日
    ,asset_class varchar2(50) -- 资产/负债类别
    ,concrete_class varchar2(50) -- 具体类别
    ,concrete_class_sm varchar2(50) -- 具体类别说明
    ,issuer_scale_type varchar2(50) -- 发行机构类型（按规模划分）
    ,issuer_technology_type varchar2(50) -- 发行机构类型（按技术领域划分）
    ,issuer_economic_type varchar2(50) -- 发行机构类型（按经济领域划分）
    ,issuer_desc varchar2(50) -- 发行机构类型说明
    ,issuer_institutions varchar2(50) -- 发行机构所属行业
    ,city_invest_sec_chb varchar2(50) -- 是否城投债（中债）
    ,city_invest_sec_provinces varchar2(50) -- 城投债省及省会（单列市）
    ,city_invest_sec_cities varchar2(50) -- 城投债地级市
    ,city_invest_sec_county varchar2(50) -- 城投债县及县级市
    ,city_invest_sec_wind varchar2(50) -- 是否城投债（wind）
    ,city_invest_sec_cbrc varchar2(50) -- 是否城投债（银监）
    ,issuer_institutions_second varchar2(50) -- 
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
grant select on ${iol_schema}.fams_interf_payhsrcsecinfo to ${iml_schema};
grant select on ${iol_schema}.fams_interf_payhsrcsecinfo to ${icl_schema};
grant select on ${iol_schema}.fams_interf_payhsrcsecinfo to ${idl_schema};
grant select on ${iol_schema}.fams_interf_payhsrcsecinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_interf_payhsrcsecinfo is '债券基本信息数据';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.secid is '债券id：xxxx.ib/xxxx.sz';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.secname is '债券简称';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.seccode is '债券code';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.market is '市场';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.secfullname is '债券全称';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.ratebasic is '计息基准：参考右边明细';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.couponspecies is '息票品种 npv付息 dis贴现 iam利随本清 zco零息';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.interestrate is '利率类型 fi固定，fl浮动';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.vdate is '起息日';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.mdate is '到期日';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.paycycle is '付息频率';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.facevalue is '面额 默认100';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issueprice is '发行价';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.paperir is '票面利率';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.schecalrule is '付息区间推算方法 vf起息日向后，mb到期日向前，fd首次付息日';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.firstrateday is '首次付息日';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.workdayrule is '营业日准则 p向前调整 s向后调整 m调整的向后 n不调整';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuershort is '发行人';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.resettype is '利率调整规则';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.observebefday is '延后时间';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.observebefunit is '延后时间单位';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.toprate is '利率上限';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.bottomrate is '利率下限';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issueamt is '发行总额';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.ratecode is '浮动利率code';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.spreadrate_8 is '浮动利差';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.coefficient is '浮动系数';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.sectype is '系统债券类型：';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.sectype2 is '系统债券类型：';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.chbsectype is '中债债券类型：';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.chbsectype2 is '中债债券类型：';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.pbocsectype is '人行债券类型：';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.pbocsectype2 is '人行债券类型：';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.remark is '备注';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issecbond is '是否次级债,y是n否';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issus is '是否永续债,y是n否';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.calloption is '是否可赎回,y是n否';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.putoption is '是否可回售,y是n否';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.institution is '登记托管机构';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.institutiontext is '登记托管机构说明';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.markettext is '交易场所说明';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.market2 is '交易流通场所：01 银行间市场、02 商业银行柜台市场、03 上海交易所、04 深圳交易所、99 其它';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.ccy is '币种 cny 人民币、hkd 港币、jpy 日元、usd 美元';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuetype is '发行方式';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.blnarea is '境内外';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.guarantor is '担保人';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.guartype is '担保方式';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.create_user is '创建人';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.create_dept is '创建部门';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.create_time is '创建时间';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.update_user is '更新人';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.update_time is '更新时间';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.source is '数据来源';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.pubenddate is '发行截止日';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.asset_class is '资产/负债类别';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.concrete_class is '具体类别';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.concrete_class_sm is '具体类别说明';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuer_scale_type is '发行机构类型（按规模划分）';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuer_technology_type is '发行机构类型（按技术领域划分）';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuer_economic_type is '发行机构类型（按经济领域划分）';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuer_desc is '发行机构类型说明';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuer_institutions is '发行机构所属行业';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.city_invest_sec_chb is '是否城投债（中债）';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.city_invest_sec_provinces is '城投债省及省会（单列市）';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.city_invest_sec_cities is '城投债地级市';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.city_invest_sec_county is '城投债县及县级市';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.city_invest_sec_wind is '是否城投债（wind）';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.city_invest_sec_cbrc is '是否城投债（银监）';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.issuer_institutions_second is '';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.start_dt is '开始时间';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.end_dt is '结束时间';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.id_mark is '增删标志';
comment on column ${iol_schema}.fams_interf_payhsrcsecinfo.etl_timestamp is 'ETL处理时间戳';

/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t09_corp_cust_supplement_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t09_corp_cust_supplement_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t09_corp_cust_supplement_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t09_corp_cust_supplement_info(
    custno varchar2(30) -- 客户号
    ,lncdpw varchar2(12) -- 贷款卡密码
    ,lncdtg varchar2(2) -- 贷款卡状态
    ,lncddt varchar2(12) -- 贷款卡年审日期
    ,lncdst varchar2(3) -- 贷款卡年审结果
    ,lcditg varchar2(2) -- 贷款卡吊销标志
    ,lcdidt varchar2(12) -- 贷款卡吊销日期
    ,lcdrdt varchar2(12) -- 贷款卡恢复日期
    ,upcrna varchar2(90) -- 主管单位名称
    ,uprgcy varchar2(3) -- 主管单位注册币种
    ,uprgam number(18,2) -- 主管单位注册金额
    ,upcrps varchar2(30) -- 主管单位法定代表人
    ,upidtp varchar2(30) -- 主管单位法定代表人证件类别
    ,upidno varchar2(30) -- 主管单位法定代表人证件号
    ,upopno varchar2(30) -- 主管单位基本户开户许可证号
    ,upcpcd varchar2(30) -- 主管单位组织机构代码
    ,upcped varchar2(12) -- 主管单位组织机构代码有效期
    ,retxtg varchar2(2) -- 是否办理税务登记证
    ,txdpid varchar2(90) -- 税务机关证明
    ,iscuim varchar2(2) -- 是否国家重点企业
    ,ishtch varchar2(2) -- 是否高新技术企业
    ,stckam number(18,2) -- 拥有我行股份数
    ,isgrup varchar2(2) -- 是否集团公司
    ,gropid varchar2(30) -- 集团客户id
    ,isgrmo varchar2(2) -- 是否占用集团客户额度
    ,ctylev varchar2(8) -- 行业类型(国标)
    ,waylv5 varchar2(15) -- 行业类型(五级分类)
    ,etpcht varchar2(15) -- 行业类型(信用评级)
    ,cuslv3 varchar2(2) -- 事业法人规模或级别
    ,custp3 varchar2(2) -- 事业法人客户类型
    ,lmtway varchar2(15) -- 限制或鼓励行业
    ,rpmltp varchar2(3) -- 财务报表类型
    ,retinm number(20) -- 离退休人数
    ,unvrnm number(20) -- 大专以上人数
    ,isdrec varchar2(2) -- 有无董事会
    ,provce varchar2(150) -- 所在省市
    ,inoutp varchar2(2) -- 收支方式
    ,worang varchar2(383) -- 职能范围
    ,supeor varchar2(150) -- 上级主管部门
    ,buldmy number(18,2) -- 开办资金
    ,budgtp varchar2(150) -- 预算形式
    ,orgown varchar2(150) -- 机构隶属
    ,cdradt varchar2(12) -- 与我行首次建立信贷关系日期
    ,prfd01 varchar2(90) -- 预留字段
    ,prfd02 varchar2(90) -- 预留字段2(组织机构类别细分)
    ,prfd03 varchar2(90) -- 预留字段3(机构状态)
    ,prfd04 number(18,2) -- 预留字段
    ,prfd05 number(18,2) -- 预留字段
    ,salmon number(18,2) -- 销售额
    ,sizehy varchar2(12) -- 企业规模行业
    ,isbank varchar2(2) -- 是否是银监小企业
    ,banksz varchar2(2) -- 银监小企业规模
    ,xwqyid varchar2(2) -- 未知字段1（继承老cif）
    ,jjzzxs varchar2(3) -- 经济组织形式
    ,jjbmlx varchar2(12) -- 国民经济部门类型
    ,caccno varchar2(30) -- 未知字段2（继承老cif）
    ,econtp varchar2(15) -- 经济类型
    ,teleno varchar2(150) -- 联系电话(征信)
    ,vocamx varchar2(30) -- 行业代码明细(征信)
    ,psrntg varchar2(3) -- 居民标示
    ,lwctna varchar2(150) -- 法人代表
    ,lwidno varchar2(150) -- 法人代表证件号码
    ,cptnnm varchar2(90) -- 法人代表证明书编号
    ,vocatp varchar2(12) -- 所属行业
    ,rgstad varchar2(30) -- 地区代码
    ,regidt varchar2(12) -- 注册日期
    ,regiad varchar2(300) -- 注册地址
    ,operar varchar2(383) -- 经营场地面积
    ,custlv varchar2(15) -- 客户级别
    ,statlv varchar2(15) -- 当前评级状态
    ,jonttg varchar2(2) -- 联名客户标志
    ,doubtp varchar2(15) -- 疑似客户类型
    ,tttrib number(18,2) -- 综合贡献度
    ,ttrema number(18,2) -- 客户总积分
    ,risklv varchar2(15) -- 风险等级
    ,datatp varchar2(15) -- 数据类型
    ,roletp varchar2(15) -- 参与者类别
    ,isincu varchar2(2) -- 是否系统内客户
    ,iscred varchar2(2) -- 是否授信客户
    ,credid varchar2(15) -- 信用评级id
    ,credln number(18,2) -- 授信额度
    ,bankno varchar2(30) -- 银行行号
    ,banklv varchar2(12) -- 行级别
    ,bktpid varchar2(30) -- 行分类id
    ,jjdl varchar2(30) -- 国民经济类型
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
grant select on ${iol_schema}.eifs_t09_corp_cust_supplement_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t09_corp_cust_supplement_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t09_corp_cust_supplement_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t09_corp_cust_supplement_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t09_corp_cust_supplement_info is '对公补录信息';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.custno is '客户号';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lncdpw is '贷款卡密码';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lncdtg is '贷款卡状态';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lncddt is '贷款卡年审日期';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lncdst is '贷款卡年审结果';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lcditg is '贷款卡吊销标志';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lcdidt is '贷款卡吊销日期';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lcdrdt is '贷款卡恢复日期';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.upcrna is '主管单位名称';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.uprgcy is '主管单位注册币种';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.uprgam is '主管单位注册金额';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.upcrps is '主管单位法定代表人';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.upidtp is '主管单位法定代表人证件类别';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.upidno is '主管单位法定代表人证件号';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.upopno is '主管单位基本户开户许可证号';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.upcpcd is '主管单位组织机构代码';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.upcped is '主管单位组织机构代码有效期';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.retxtg is '是否办理税务登记证';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.txdpid is '税务机关证明';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.iscuim is '是否国家重点企业';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.ishtch is '是否高新技术企业';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.stckam is '拥有我行股份数';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.isgrup is '是否集团公司';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.gropid is '集团客户id';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.isgrmo is '是否占用集团客户额度';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.ctylev is '行业类型(国标)';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.waylv5 is '行业类型(五级分类)';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.etpcht is '行业类型(信用评级)';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.cuslv3 is '事业法人规模或级别';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.custp3 is '事业法人客户类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lmtway is '限制或鼓励行业';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.rpmltp is '财务报表类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.retinm is '离退休人数';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.unvrnm is '大专以上人数';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.isdrec is '有无董事会';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.provce is '所在省市';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.inoutp is '收支方式';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.worang is '职能范围';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.supeor is '上级主管部门';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.buldmy is '开办资金';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.budgtp is '预算形式';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.orgown is '机构隶属';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.cdradt is '与我行首次建立信贷关系日期';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.prfd01 is '预留字段';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.prfd02 is '预留字段2(组织机构类别细分)';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.prfd03 is '预留字段3(机构状态)';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.prfd04 is '预留字段';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.prfd05 is '预留字段';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.salmon is '销售额';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.sizehy is '企业规模行业';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.isbank is '是否是银监小企业';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.banksz is '银监小企业规模';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.xwqyid is '未知字段1（继承老cif）';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.jjzzxs is '经济组织形式';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.jjbmlx is '国民经济部门类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.caccno is '未知字段2（继承老cif）';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.econtp is '经济类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.teleno is '联系电话(征信)';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.vocamx is '行业代码明细(征信)';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.psrntg is '居民标示';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lwctna is '法人代表';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.lwidno is '法人代表证件号码';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.cptnnm is '法人代表证明书编号';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.vocatp is '所属行业';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.rgstad is '地区代码';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.regidt is '注册日期';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.regiad is '注册地址';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.operar is '经营场地面积';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.custlv is '客户级别';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.statlv is '当前评级状态';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.jonttg is '联名客户标志';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.doubtp is '疑似客户类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.tttrib is '综合贡献度';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.ttrema is '客户总积分';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.risklv is '风险等级';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.datatp is '数据类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.roletp is '参与者类别';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.isincu is '是否系统内客户';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.iscred is '是否授信客户';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.credid is '信用评级id';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.credln is '授信额度';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.bankno is '银行行号';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.banklv is '行级别';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.bktpid is '行分类id';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.jjdl is '国民经济类型';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t09_corp_cust_supplement_info.etl_timestamp is 'ETL处理时间戳';

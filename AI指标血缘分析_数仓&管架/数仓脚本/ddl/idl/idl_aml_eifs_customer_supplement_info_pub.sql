/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_eifs_customer_supplement_info_pub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_eifs_customer_supplement_info_pub
whenever sqlerror continue none;
drop table ${idl_schema}.aml_eifs_customer_supplement_info_pub purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_eifs_customer_supplement_info_pub(
    custno varchar2(20) -- CIF客户号
    ,lncdpw varchar2(8) -- 贷款卡密码
    ,lncdtg varchar2(1) -- 贷款卡状态
    ,lncddt varchar2(8) -- 贷款卡年审日期
    ,lncdst varchar2(2) -- 贷款卡年审结果
    ,lcditg varchar2(1) -- 贷款卡吊销标志
    ,lcdidt varchar2(8) -- 贷款卡吊销日期
    ,lcdrdt varchar2(8) -- 贷款卡恢复日期
    ,upcrna varchar2(60) -- 主管单位名称
    ,uprgcy varchar2(2) -- 主管单位注册币种
    ,uprgam number(18,2) -- 主管单位注册金额
    ,upcrps varchar2(20) -- 主管单位法定代表人
    ,upidtp varchar2(20) -- 主管单位法定代表人证件类别
    ,upidno varchar2(20) -- 主管单位法定代表人证件号
    ,upopno varchar2(20) -- 主管单位基本户开户许可证号
    ,upcpcd varchar2(20) -- 主管单位组织机构代码
    ,upcped varchar2(8) -- 主管单位组织机构代码有效期
    ,retxtg varchar2(1) -- 是否办理税务登记证
    ,txdpid varchar2(60) -- 税务机关证明
    ,iscuim varchar2(1) -- 是否国家重点企业
    ,ishtch varchar2(1) -- 是否高新技术企业
    ,stckam number(18,2) -- 拥有我行股份数
    ,isgrup varchar2(1) -- 是否集团公司
    ,gropid varchar2(20) -- 集团客户id
    ,isgrmo varchar2(1) -- 是否占用集团客户额度
    ,ctylev varchar2(1) -- 行业类型(国标)
    ,waylv5 varchar2(10) -- 行业类型(五级分类)
    ,etpcht varchar2(10) -- 行业类型(信用评级)
    ,cuslv3 varchar2(1) -- 事业法人规模或级别
    ,custp3 varchar2(1) -- 事业法人客户类型
    ,lmtway varchar2(10) -- 限制或鼓励行业
    ,rpmltp varchar2(2) -- 财务报表类型
    ,retinm number(20) -- 离退休人数
    ,unvrnm number(20) -- 大专以上人数
    ,isdrec varchar2(1) -- 有无董事会
    ,provce varchar2(100) -- 所在省市
    ,inoutp varchar2(1) -- 收支方式
    ,worang varchar2(255) -- 职能范围
    ,supeor varchar2(100) -- 上级主管部门
    ,buldmy number(18,2) -- 开办资金
    ,budgtp varchar2(100) -- 预算形式
    ,orgown varchar2(100) -- 机构隶属
    ,cdradt varchar2(8) -- 与我行首次建立信贷关系日期
    ,prfd01 varchar2(60) -- 预留字段
    ,prfd02 varchar2(60) -- 预留字段2(组织机构类别细分)
    ,prfd03 varchar2(60) -- 预留字段3(机构状态)
    ,prfd04 number(18,2) -- 预留字段
    ,prfd05 number(18,2) -- 预留字段
    ,salmon number(18,2) -- 销售额
    ,sizehy varchar2(8) -- 企业规模行业
    ,isbank varchar2(1) -- 是否是银监小企业
    ,banksz varchar2(1) -- 银监小企业规模
    ,xwqyid varchar2(1) -- 未知字段1（继承老cif）
    ,jjzzxs varchar2(2) -- 经济组织形式
    ,jjbmlx varchar2(8) -- 国民经济部门类型
    ,caccno varchar2(20) -- 未知字段2（继承老cif）
    ,econtp varchar2(10) -- 经济类型
    ,teleno varchar2(100) -- 联系电话(征信)
    ,vocamx varchar2(20) -- 行业代码明细(征信)
    ,psrntg varchar2(2) -- 居民标示
    ,lwctna varchar2(100) -- 法人代表
    ,lwidno varchar2(100) -- 法人代表证件号码
    ,cptnnm varchar2(60) -- 法人代表证明书编号
    ,vocatp varchar2(8) -- 所属行业
    ,rgstad varchar2(20) -- 地区代码
    ,regidt varchar2(8) -- 注册日期
    ,regiad varchar2(200) -- 注册地址
    ,operar varchar2(255) -- 经营场地面积
    ,custlv varchar2(10) -- 客户级别
    ,statlv varchar2(10) -- 当前评级状态
    ,jonttg varchar2(1) -- 联名客户标志
    ,doubtp varchar2(10) -- 疑似客户类型
    ,tttrib number(18,2) -- 综合贡献度
    ,ttrema number(18,2) -- 客户总积分
    ,risklv varchar2(10) -- 风险等级
    ,datatp varchar2(10) -- 数据类型
    ,roletp varchar2(10) -- 参与者类别
    ,isincu varchar2(1) -- 是否系统内客户
    ,iscred varchar2(1) -- 是否授信客户
    ,credid varchar2(10) -- 信用评级ID
    ,credln number(18,2) -- 授信额度
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,bankno varchar2(20) -- 银行行号
    ,banklv varchar2(8) -- 行级别
    ,bktpid varchar2(20) -- 行分类id
    ,jjdl varchar2(20) -- 国民经济类型
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
    ,etl_dt date -- ETL处理日期
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_eifs_customer_supplement_info_pub to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_eifs_customer_supplement_info_pub is '客户补录信息(对公)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.custno is 'CIF客户号';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lncdpw is '贷款卡密码';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lncdtg is '贷款卡状态';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lncddt is '贷款卡年审日期';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lncdst is '贷款卡年审结果';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lcditg is '贷款卡吊销标志';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lcdidt is '贷款卡吊销日期';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lcdrdt is '贷款卡恢复日期';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.upcrna is '主管单位名称';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.uprgcy is '主管单位注册币种';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.uprgam is '主管单位注册金额';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.upcrps is '主管单位法定代表人';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.upidtp is '主管单位法定代表人证件类别';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.upidno is '主管单位法定代表人证件号';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.upopno is '主管单位基本户开户许可证号';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.upcpcd is '主管单位组织机构代码';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.upcped is '主管单位组织机构代码有效期';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.retxtg is '是否办理税务登记证';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.txdpid is '税务机关证明';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.iscuim is '是否国家重点企业';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.ishtch is '是否高新技术企业';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.stckam is '拥有我行股份数';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.isgrup is '是否集团公司';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.gropid is '集团客户id';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.isgrmo is '是否占用集团客户额度';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.ctylev is '行业类型(国标)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.waylv5 is '行业类型(五级分类)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.etpcht is '行业类型(信用评级)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.cuslv3 is '事业法人规模或级别';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.custp3 is '事业法人客户类型';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lmtway is '限制或鼓励行业';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.rpmltp is '财务报表类型';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.retinm is '离退休人数';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.unvrnm is '大专以上人数';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.isdrec is '有无董事会';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.provce is '所在省市';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.inoutp is '收支方式';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.worang is '职能范围';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.supeor is '上级主管部门';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.buldmy is '开办资金';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.budgtp is '预算形式';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.orgown is '机构隶属';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.cdradt is '与我行首次建立信贷关系日期';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.prfd01 is '预留字段';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.prfd02 is '预留字段2(组织机构类别细分)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.prfd03 is '预留字段3(机构状态)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.prfd04 is '预留字段';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.prfd05 is '预留字段';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.salmon is '销售额';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.sizehy is '企业规模行业';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.isbank is '是否是银监小企业';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.banksz is '银监小企业规模';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.xwqyid is '未知字段1（继承老cif）';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.jjzzxs is '经济组织形式';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.jjbmlx is '国民经济部门类型';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.caccno is '未知字段2（继承老cif）';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.econtp is '经济类型';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.teleno is '联系电话(征信)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.vocamx is '行业代码明细(征信)';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.psrntg is '居民标示';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lwctna is '法人代表';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.lwidno is '法人代表证件号码';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.cptnnm is '法人代表证明书编号';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.vocatp is '所属行业';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.rgstad is '地区代码';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.regidt is '注册日期';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.regiad is '注册地址';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.operar is '经营场地面积';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.custlv is '客户级别';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.statlv is '当前评级状态';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.jonttg is '联名客户标志';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.doubtp is '疑似客户类型';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.tttrib is '综合贡献度';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.ttrema is '客户总积分';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.risklv is '风险等级';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.datatp is '数据类型';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.roletp is '参与者类别';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.isincu is '是否系统内客户';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.iscred is '是否授信客户';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.credid is '信用评级ID';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.credln is '授信额度';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.last_updated_stamp is '最后更新时间';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.created_stamp is '创建时间';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.created_tx_stamp is '创建事务时间';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.bankno is '银行行号';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.banklv is '行级别';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.bktpid is '行分类id';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.jjdl is '国民经济类型';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.start_dt is '开始时间';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.end_dt is '结束时间';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.id_mark is '增删标志';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.etl_timestamp is 'ETL处理时间戳';
comment on column ${idl_schema}.aml_eifs_customer_supplement_info_pub.etl_dt is 'ETL处理日期';
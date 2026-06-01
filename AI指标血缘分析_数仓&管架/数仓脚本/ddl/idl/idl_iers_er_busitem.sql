/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl iers_er_busitem
CreateDate: 20260309
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.iers_er_busitem purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.iers_er_busitem(
amount number(28,8) --金额
,bbhl number(28,8) --本币汇率
,bbje number(28,8) --本币金额
,bbye number(28,8) --本币余额
,bzbm varchar2(30) --币种
,cjkbbje number(28,8) --冲借款本币金额
,cjkybje number(28,8) --冲借款金额
,companypaytype varchar2(75) --企业支付类型
,custaccount varchar2(30) --客商银行账户
,customer varchar2(30) --客户
,defitem1 varchar2(152) --自定义项1
,defitem10 varchar2(152) --自定义项10
,defitem11 varchar2(152) --自定义项11
,defitem12 varchar2(152) --自定义项12
,defitem13 varchar2(152) --自定义项13
,defitem14 varchar2(152) --自定义项14
,defitem15 varchar2(152) --自定义项15
,defitem16 varchar2(152) --自定义项16
,defitem17 varchar2(152) --自定义项17
,defitem18 varchar2(152) --自定义项18
,defitem19 varchar2(152) --自定义项19
,defitem2 varchar2(152) --自定义项2
,defitem20 varchar2(152) --自定义项20
,defitem21 varchar2(152) --自定义项21
,defitem22 varchar2(152) --自定义项22
,defitem23 varchar2(152) --自定义项23
,defitem24 varchar2(152) --自定义项24
,defitem25 varchar2(152) --自定义项25
,defitem26 varchar2(152) --自定义项26
,defitem27 varchar2(152) --自定义项27
,defitem28 varchar2(152) --自定义项28
,defitem29 varchar2(152) --自定义项29
,defitem3 varchar2(152) --自定义项3
,defitem30 varchar2(152) --自定义项30
,defitem31 varchar2(152) --自定义项31
,defitem32 varchar2(152) --自定义项32
,defitem33 varchar2(152) --自定义项33
,defitem34 varchar2(152) --自定义项34
,defitem35 varchar2(152) --自定义项35
,defitem36 varchar2(152) --自定义项36
,defitem37 varchar2(152) --自定义项37
,defitem38 varchar2(152) --自定义项38
,defitem39 varchar2(152) --自定义项39
,defitem4 varchar2(152) --自定义项4
,defitem40 varchar2(152) --自定义项40
,defitem41 varchar2(152) --自定义项41
,defitem42 varchar2(152) --自定义项42
,defitem43 varchar2(152) --自定义项43
,defitem44 varchar2(152) --自定义项44
,defitem45 varchar2(152) --自定义项45
,defitem46 varchar2(152) --自定义项46
,defitem47 varchar2(152) --自定义项47
,defitem48 varchar2(152) --自定义项48
,defitem49 varchar2(152) --自定义项49
,defitem5 varchar2(152) --自定义项5
,defitem50 varchar2(152) --自定义项50
,defitem51 varchar2(152) --自定义项51
,defitem52 varchar2(152) --自定义项52
,defitem53 varchar2(152) --自定义项53
,defitem54 varchar2(152) --自定义项54
,defitem55 varchar2(152) --自定义项55
,defitem56 varchar2(152) --自定义项56
,defitem57 varchar2(152) --自定义项57
,defitem58 varchar2(152) --自定义项58
,defitem59 varchar2(152) --自定义项59
,defitem6 varchar2(152) --自定义项6
,defitem60 varchar2(152) --自定义项60
,defitem61 varchar2(152) --自定义项61
,defitem62 varchar2(152) --自定义项62
,defitem63 varchar2(152) --自定义项63
,defitem64 varchar2(152) --自定义项64
,defitem65 varchar2(152) --自定义项65
,defitem66 varchar2(152) --自定义项66
,defitem67 varchar2(152) --自定义项67
,defitem68 varchar2(152) --自定义项68
,defitem69 varchar2(152) --自定义项69
,defitem7 varchar2(152) --自定义项7
,defitem70 varchar2(152) --自定义项70
,defitem71 varchar2(152) --自定义项71
,defitem72 varchar2(152) --自定义项72
,defitem73 varchar2(152) --自定义项73
,defitem74 varchar2(152) --自定义项74
,defitem75 varchar2(152) --自定义项75
,defitem76 varchar2(152) --自定义项76
,defitem77 varchar2(152) --自定义项77
,defitem78 varchar2(152) --自定义项78
,defitem79 varchar2(152) --自定义项79
,defitem8 varchar2(152) --自定义项8
,defitem80 varchar2(152) --自定义项80
,defitem9 varchar2(152) --自定义项9
,deptid varchar2(30) --报销人部门
,dr number(10) --删除标志
,dwbm varchar2(30) --报销人单位
,fctno varchar2(30) --合同号
,fpdm varchar2(75) --发票代码
,fphm varchar2(75) --发票号码
,fplx varchar2(75) --发票类型
,freecust varchar2(30) --散户
,globalbbhl number(28,8) --全局本币汇率
,globalbbje number(28,8) --全局本币金额
,globalbbye number(28,8) --全局本币余额
,globalcjkbbje number(28,8) --全局冲借款本币金额
,globalhkbbje number(28,8) --全局还款本币金额
,globaltax_amount number(28,8) --全局税金本币金额
,globaltni_amount number(28,8) --全局不含税本币金额
,globalvat_amount number(28,8) --全局含税本币金额
,globalzfbbje number(28,8) --全局支付本币金额
,groupbbhl number(28,8) --集团本币汇率
,groupbbje number(28,8) --集团本币金额
,groupbbye number(28,8) --集团本币余额
,groupcjkbbje number(28,8) --集团冲借款本币金额
,grouphkbbje number(28,8) --集团还款本币金额
,grouptax_amount number(28,8) --集团税金本币金额
,grouptni_amount number(28,8) --集团不含税本币金额
,groupvat_amount number(28,8) --集团含税本币金额
,groupzfbbje number(28,8) --集团支付本币金额
,hbbm varchar2(30) --供应商
,hkbbje number(28,8) --还款本币金额
,hkybje number(28,8) --还款金额
,iscompanypay varchar2(2) --是否企业支付
,jkbxr varchar2(30) --报销人
,jobid varchar2(30) --项目
,jsfs varchar2(30) --结算方式
,orgtax_amount number(28,8) --税金组织本币金额
,orgtni_amount number(28,8) --不含税组织本位币金额
,orgvat_amount number(28,8) --含税组织本位币金额
,paytarget number(38) --收款对象
,pk_brand varchar2(30) --品牌
,pk_busitem varchar2(30) --报销单业务行标识
,pk_checkele varchar2(30) --核算要素
,pk_crmdetail varchar2(30) --pk_crm
,pk_fprelation varchar2(30) --关联发票
,pk_item varchar2(30) --费用申请单
,pk_jkbx varchar2(30) --报销单标识
,pk_mtapp_detail varchar2(30) --费用申请单明细
,pk_pcorg varchar2(30) --利润中心
,pk_pcorg_v varchar2(30) --利润中心历史版本
,pk_proline varchar2(30) --产品线
,pk_reimtype varchar2(30) --报销类型
,pk_resacostcenter varchar2(30) --成本中心
,projecttask varchar2(30) --项目任务
,receiver varchar2(30) --收款人
,rowno number(38) --行号
,sfcb varchar2(30) --是否超标
,skyhzh varchar2(30) --个人银行账户
,src_ybz_id varchar2(75) --友报账id
,srcbilltype varchar2(75) --来源单据类型
,srctype varchar2(75) --来源类型
,szxmid varchar2(30) --收支项目
,tablecode varchar2(30) --页签编码
,tax_amount number(28,8) --税金金额
,tax_rate number(28,8) --税率
,tni_amount number(28,8) --不含税金额
,ts varchar2(29) --时间戳
,vat_amount number(28,8) --含税金额
,ybje number(28,8) --原币金额
,ybye number(28,8) --原币余额
,yjye number(28,8) --预计余额
,zfbbje number(28,8) --支付本币金额
,zfybje number(28,8) --支付金额
,fplxpk varchar2(75) --发票类型主键
,generatetype varchar2(75) --发票生成方式
,pk_erminvoice varchar2(30) --关联发票
,pk_erminvoice_b varchar2(30) --关联发票明细
,jxzcje number(28,8) --进项转出金额
,stxsje number(28,8) --视同销售金额
,qualitydeposit number(28,8) --质保金
,pk_resource varchar2(30) --
,pk_resource_b varchar2(30) --单据来源子表主键
,remark varchar2(150) --备注2
,leavedate varchar2(29) --离开日期
,staydates number(38) --停留日期
,bsarrive varchar2(75) --到达
,isconverd number(38) --是否转换
,defitem_convert_reason varchar2(152) --事由
,asale_taxrate number(28,8) --税率
,asale_vat_amount number(28,8) --含税金额
,taxitem varchar2(150) --税收项目
,buytaxno varchar2(75) --购方税号
,traveldate varchar2(29) --旅行日期
,deductype number(38) --演绎类型
,enddate varchar2(29) --结束日期
,arrivedate varchar2(29) --到达日期
,taxperiod varchar2(75) --税期
,converexplain varchar2(75) --自定义
,traffictools varchar2(75) --交通工具
,subsidycosts number(28,8) --补贴成本
,standardcosts number(28,8) --标准成本
,arrive varchar2(75) --到达
,defitem_asale_reason varchar2(152) --事由
,buyname varchar2(75) --买名
,leave varchar2(75) --离开
,asale_tni_amount number(28,8) --不含税金额
,notes varchar2(75) --备注
,asale_explain varchar2(75) --解释
,convert_tax number(28,8) --销项税
,input_tax number(28,8) --进项税
,companyrealpay number(28,8) --公司实付金额
,pk_trip_orderno varchar2(180) --指令状态
,asale_tax number(28,8) --税
,isdeemedsale number(38) --是否视同销售
,startdate varchar2(29) --开始日期
,defitem81 varchar2(3000) --自定义项81
,defitem82 varchar2(3000) --自定义项82
,defitem83 varchar2(3000) --自定义项83
,defitem84 varchar2(3000) --自定义项84
,defitem85 varchar2(3000) --自定义项85
,defitem86 varchar2(3000) --自定义项86
,defitem87 varchar2(4000) --自定义项87
,defitem88 varchar2(3000) --自定义项88
,defitem89 varchar2(3000) --自定义项89
,defitem90 varchar2(3000) --自定义项90
,defitem91 varchar2(3000) --自定义项91
,defitem92 varchar2(3000) --自定义项92
,defitem93 varchar2(3000) --自定义项93
,defitem94 varchar2(3000) --自定义项94
,defitem95 varchar2(3000) --自定义项95
,defitem96 varchar2(3000) --自定义项96
,defitem97 varchar2(3000) --自定义项97
,defitem98 varchar2(3000) --自定义项98
,defitem99 varchar2(3000) --自定义项99
,defitem100 varchar2(3000) --自定义项100
,defitem101 varchar2(3000) --自定义项101
,defitem102 varchar2(3000) --自定义项102
,defitem103 varchar2(3000) --自定义项103
,defitem104 varchar2(3000) --自定义项104
,defitem105 varchar2(3000) --自定义项105
,defitem106 varchar2(3000) --自定义项106
,defitem107 varchar2(3000) --自定义项107
,defitem108 varchar2(3000) --自定义项108
,defitem109 varchar2(3000) --自定义项109
,defitem110 varchar2(3000) --自定义项110
,defitem111 varchar2(3000) --自定义项111
,defitem112 varchar2(3000) --自定义项112
,defitem113 varchar2(3000) --自定义项113
,defitem114 varchar2(3000) --自定义项114
,defitem115 varchar2(3000) --自定义项115
,defitem116 varchar2(3000) --自定义项116
,defitem117 varchar2(3000) --自定义项117
,defitem118 varchar2(3000) --自定义项118
,defitem119 varchar2(3000) --自定义项119
,defitem120 varchar2(3000) --自定义项120
,defitem121 varchar2(3000) --自定义项121
,defitem122 varchar2(3000) --自定义项122
,defitem123 varchar2(3000) --自定义项123
,defitem124 varchar2(3000) --自定义项124
,defitem125 varchar2(3000) --自定义项125
,defitem126 varchar2(3000) --自定义项126
,defitem127 varchar2(3000) --自定义项127
,defitem128 varchar2(3000) --自定义项128
,defitem129 varchar2(3000) --自定义项129
,defitem130 varchar2(3000) --自定义项130
,defitem131 varchar2(3000) --自定义项131
,defitem132 varchar2(3000) --自定义项132
,defitem133 varchar2(3000) --自定义项133
,defitem134 varchar2(3000) --自定义项134
,defitem135 varchar2(3000) --自定义项135
,defitem136 varchar2(3000) --自定义项136
,defitem137 varchar2(3000) --自定义项137
,defitem138 varchar2(3000) --自定义项138
,defitem139 varchar2(3000) --自定义项139
,defitem140 varchar2(3000) --自定义项140
,defitem141 varchar2(4000) --自定义项141
,defitem142 varchar2(4000) --自定义项142
,defitem143 varchar2(4000) --自定义项143
,defitem144 varchar2(4000) --自定义项144
,defitem145 varchar2(4000) --自定义项145
,defitem146 varchar2(4000) --自定义项146
,defitem147 varchar2(4000) --自定义项147
,defitem148 varchar2(4000) --自定义项148
,defitem149 varchar2(4000) --自定义项149
,defitem150 varchar2(4000) --自定义项150
,defitem151 varchar2(4000) --自定义项151
,defitem152 varchar2(4000) --自定义项152
,defitem153 varchar2(4000) --自定义项153
,defitem154 varchar2(4000) --自定义项154
,defitem155 varchar2(4000) --自定义项155
,defitem156 varchar2(4000) --自定义项156
,defitem157 varchar2(4000) --自定义项157
,defitem158 varchar2(4000) --自定义项158
,defitem159 varchar2(4000) --自定义项159
,defitem160 varchar2(4000) --自定义项160
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,etl_dt date --ETL处理时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.iers_er_busitem to ${iel_schema};

-- comment
comment on table ${idl_schema}.iers_er_busitem is '新费用明细表(子表)';
comment on column ${idl_schema}.iers_er_busitem.amount is '金额';
comment on column ${idl_schema}.iers_er_busitem.bbhl is '本币汇率';
comment on column ${idl_schema}.iers_er_busitem.bbje is '本币金额';
comment on column ${idl_schema}.iers_er_busitem.bbye is '本币余额';
comment on column ${idl_schema}.iers_er_busitem.bzbm is '币种';
comment on column ${idl_schema}.iers_er_busitem.cjkbbje is '冲借款本币金额';
comment on column ${idl_schema}.iers_er_busitem.cjkybje is '冲借款金额';
comment on column ${idl_schema}.iers_er_busitem.companypaytype is '企业支付类型';
comment on column ${idl_schema}.iers_er_busitem.custaccount is '客商银行账户';
comment on column ${idl_schema}.iers_er_busitem.customer is '客户';
comment on column ${idl_schema}.iers_er_busitem.defitem1 is '自定义项1';
comment on column ${idl_schema}.iers_er_busitem.defitem10 is '自定义项10';
comment on column ${idl_schema}.iers_er_busitem.defitem11 is '自定义项11';
comment on column ${idl_schema}.iers_er_busitem.defitem12 is '自定义项12';
comment on column ${idl_schema}.iers_er_busitem.defitem13 is '自定义项13';
comment on column ${idl_schema}.iers_er_busitem.defitem14 is '自定义项14';
comment on column ${idl_schema}.iers_er_busitem.defitem15 is '自定义项15';
comment on column ${idl_schema}.iers_er_busitem.defitem16 is '自定义项16';
comment on column ${idl_schema}.iers_er_busitem.defitem17 is '自定义项17';
comment on column ${idl_schema}.iers_er_busitem.defitem18 is '自定义项18';
comment on column ${idl_schema}.iers_er_busitem.defitem19 is '自定义项19';
comment on column ${idl_schema}.iers_er_busitem.defitem2 is '自定义项2';
comment on column ${idl_schema}.iers_er_busitem.defitem20 is '自定义项20';
comment on column ${idl_schema}.iers_er_busitem.defitem21 is '自定义项21';
comment on column ${idl_schema}.iers_er_busitem.defitem22 is '自定义项22';
comment on column ${idl_schema}.iers_er_busitem.defitem23 is '自定义项23';
comment on column ${idl_schema}.iers_er_busitem.defitem24 is '自定义项24';
comment on column ${idl_schema}.iers_er_busitem.defitem25 is '自定义项25';
comment on column ${idl_schema}.iers_er_busitem.defitem26 is '自定义项26';
comment on column ${idl_schema}.iers_er_busitem.defitem27 is '自定义项27';
comment on column ${idl_schema}.iers_er_busitem.defitem28 is '自定义项28';
comment on column ${idl_schema}.iers_er_busitem.defitem29 is '自定义项29';
comment on column ${idl_schema}.iers_er_busitem.defitem3 is '自定义项3';
comment on column ${idl_schema}.iers_er_busitem.defitem30 is '自定义项30';
comment on column ${idl_schema}.iers_er_busitem.defitem31 is '自定义项31';
comment on column ${idl_schema}.iers_er_busitem.defitem32 is '自定义项32';
comment on column ${idl_schema}.iers_er_busitem.defitem33 is '自定义项33';
comment on column ${idl_schema}.iers_er_busitem.defitem34 is '自定义项34';
comment on column ${idl_schema}.iers_er_busitem.defitem35 is '自定义项35';
comment on column ${idl_schema}.iers_er_busitem.defitem36 is '自定义项36';
comment on column ${idl_schema}.iers_er_busitem.defitem37 is '自定义项37';
comment on column ${idl_schema}.iers_er_busitem.defitem38 is '自定义项38';
comment on column ${idl_schema}.iers_er_busitem.defitem39 is '自定义项39';
comment on column ${idl_schema}.iers_er_busitem.defitem4 is '自定义项4';
comment on column ${idl_schema}.iers_er_busitem.defitem40 is '自定义项40';
comment on column ${idl_schema}.iers_er_busitem.defitem41 is '自定义项41';
comment on column ${idl_schema}.iers_er_busitem.defitem42 is '自定义项42';
comment on column ${idl_schema}.iers_er_busitem.defitem43 is '自定义项43';
comment on column ${idl_schema}.iers_er_busitem.defitem44 is '自定义项44';
comment on column ${idl_schema}.iers_er_busitem.defitem45 is '自定义项45';
comment on column ${idl_schema}.iers_er_busitem.defitem46 is '自定义项46';
comment on column ${idl_schema}.iers_er_busitem.defitem47 is '自定义项47';
comment on column ${idl_schema}.iers_er_busitem.defitem48 is '自定义项48';
comment on column ${idl_schema}.iers_er_busitem.defitem49 is '自定义项49';
comment on column ${idl_schema}.iers_er_busitem.defitem5 is '自定义项5';
comment on column ${idl_schema}.iers_er_busitem.defitem50 is '自定义项50';
comment on column ${idl_schema}.iers_er_busitem.defitem51 is '自定义项51';
comment on column ${idl_schema}.iers_er_busitem.defitem52 is '自定义项52';
comment on column ${idl_schema}.iers_er_busitem.defitem53 is '自定义项53';
comment on column ${idl_schema}.iers_er_busitem.defitem54 is '自定义项54';
comment on column ${idl_schema}.iers_er_busitem.defitem55 is '自定义项55';
comment on column ${idl_schema}.iers_er_busitem.defitem56 is '自定义项56';
comment on column ${idl_schema}.iers_er_busitem.defitem57 is '自定义项57';
comment on column ${idl_schema}.iers_er_busitem.defitem58 is '自定义项58';
comment on column ${idl_schema}.iers_er_busitem.defitem59 is '自定义项59';
comment on column ${idl_schema}.iers_er_busitem.defitem6 is '自定义项6';
comment on column ${idl_schema}.iers_er_busitem.defitem60 is '自定义项60';
comment on column ${idl_schema}.iers_er_busitem.defitem61 is '自定义项61';
comment on column ${idl_schema}.iers_er_busitem.defitem62 is '自定义项62';
comment on column ${idl_schema}.iers_er_busitem.defitem63 is '自定义项63';
comment on column ${idl_schema}.iers_er_busitem.defitem64 is '自定义项64';
comment on column ${idl_schema}.iers_er_busitem.defitem65 is '自定义项65';
comment on column ${idl_schema}.iers_er_busitem.defitem66 is '自定义项66';
comment on column ${idl_schema}.iers_er_busitem.defitem67 is '自定义项67';
comment on column ${idl_schema}.iers_er_busitem.defitem68 is '自定义项68';
comment on column ${idl_schema}.iers_er_busitem.defitem69 is '自定义项69';
comment on column ${idl_schema}.iers_er_busitem.defitem7 is '自定义项7';
comment on column ${idl_schema}.iers_er_busitem.defitem70 is '自定义项70';
comment on column ${idl_schema}.iers_er_busitem.defitem71 is '自定义项71';
comment on column ${idl_schema}.iers_er_busitem.defitem72 is '自定义项72';
comment on column ${idl_schema}.iers_er_busitem.defitem73 is '自定义项73';
comment on column ${idl_schema}.iers_er_busitem.defitem74 is '自定义项74';
comment on column ${idl_schema}.iers_er_busitem.defitem75 is '自定义项75';
comment on column ${idl_schema}.iers_er_busitem.defitem76 is '自定义项76';
comment on column ${idl_schema}.iers_er_busitem.defitem77 is '自定义项77';
comment on column ${idl_schema}.iers_er_busitem.defitem78 is '自定义项78';
comment on column ${idl_schema}.iers_er_busitem.defitem79 is '自定义项79';
comment on column ${idl_schema}.iers_er_busitem.defitem8 is '自定义项8';
comment on column ${idl_schema}.iers_er_busitem.defitem80 is '自定义项80';
comment on column ${idl_schema}.iers_er_busitem.defitem9 is '自定义项9';
comment on column ${idl_schema}.iers_er_busitem.deptid is '报销人部门';
comment on column ${idl_schema}.iers_er_busitem.dr is '删除标志';
comment on column ${idl_schema}.iers_er_busitem.dwbm is '报销人单位';
comment on column ${idl_schema}.iers_er_busitem.fctno is '合同号';
comment on column ${idl_schema}.iers_er_busitem.fpdm is '发票代码';
comment on column ${idl_schema}.iers_er_busitem.fphm is '发票号码';
comment on column ${idl_schema}.iers_er_busitem.fplx is '发票类型';
comment on column ${idl_schema}.iers_er_busitem.freecust is '散户';
comment on column ${idl_schema}.iers_er_busitem.globalbbhl is '全局本币汇率';
comment on column ${idl_schema}.iers_er_busitem.globalbbje is '全局本币金额';
comment on column ${idl_schema}.iers_er_busitem.globalbbye is '全局本币余额';
comment on column ${idl_schema}.iers_er_busitem.globalcjkbbje is '全局冲借款本币金额';
comment on column ${idl_schema}.iers_er_busitem.globalhkbbje is '全局还款本币金额';
comment on column ${idl_schema}.iers_er_busitem.globaltax_amount is '全局税金本币金额';
comment on column ${idl_schema}.iers_er_busitem.globaltni_amount is '全局不含税本币金额';
comment on column ${idl_schema}.iers_er_busitem.globalvat_amount is '全局含税本币金额';
comment on column ${idl_schema}.iers_er_busitem.globalzfbbje is '全局支付本币金额';
comment on column ${idl_schema}.iers_er_busitem.groupbbhl is '集团本币汇率';
comment on column ${idl_schema}.iers_er_busitem.groupbbje is '集团本币金额';
comment on column ${idl_schema}.iers_er_busitem.groupbbye is '集团本币余额';
comment on column ${idl_schema}.iers_er_busitem.groupcjkbbje is '集团冲借款本币金额';
comment on column ${idl_schema}.iers_er_busitem.grouphkbbje is '集团还款本币金额';
comment on column ${idl_schema}.iers_er_busitem.grouptax_amount is '集团税金本币金额';
comment on column ${idl_schema}.iers_er_busitem.grouptni_amount is '集团不含税本币金额';
comment on column ${idl_schema}.iers_er_busitem.groupvat_amount is '集团含税本币金额';
comment on column ${idl_schema}.iers_er_busitem.groupzfbbje is '集团支付本币金额';
comment on column ${idl_schema}.iers_er_busitem.hbbm is '供应商';
comment on column ${idl_schema}.iers_er_busitem.hkbbje is '还款本币金额';
comment on column ${idl_schema}.iers_er_busitem.hkybje is '还款金额';
comment on column ${idl_schema}.iers_er_busitem.iscompanypay is '是否企业支付';
comment on column ${idl_schema}.iers_er_busitem.jkbxr is '报销人';
comment on column ${idl_schema}.iers_er_busitem.jobid is '项目';
comment on column ${idl_schema}.iers_er_busitem.jsfs is '结算方式';
comment on column ${idl_schema}.iers_er_busitem.orgtax_amount is '税金组织本币金额';
comment on column ${idl_schema}.iers_er_busitem.orgtni_amount is '不含税组织本位币金额';
comment on column ${idl_schema}.iers_er_busitem.orgvat_amount is '含税组织本位币金额';
comment on column ${idl_schema}.iers_er_busitem.paytarget is '收款对象';
comment on column ${idl_schema}.iers_er_busitem.pk_brand is '品牌';
comment on column ${idl_schema}.iers_er_busitem.pk_busitem is '报销单业务行标识';
comment on column ${idl_schema}.iers_er_busitem.pk_checkele is '核算要素';
comment on column ${idl_schema}.iers_er_busitem.pk_crmdetail is 'pk_crm';
comment on column ${idl_schema}.iers_er_busitem.pk_fprelation is '关联发票';
comment on column ${idl_schema}.iers_er_busitem.pk_item is '费用申请单';
comment on column ${idl_schema}.iers_er_busitem.pk_jkbx is '报销单标识';
comment on column ${idl_schema}.iers_er_busitem.pk_mtapp_detail is '费用申请单明细';
comment on column ${idl_schema}.iers_er_busitem.pk_pcorg is '利润中心';
comment on column ${idl_schema}.iers_er_busitem.pk_pcorg_v is '利润中心历史版本';
comment on column ${idl_schema}.iers_er_busitem.pk_proline is '产品线';
comment on column ${idl_schema}.iers_er_busitem.pk_reimtype is '报销类型';
comment on column ${idl_schema}.iers_er_busitem.pk_resacostcenter is '成本中心';
comment on column ${idl_schema}.iers_er_busitem.projecttask is '项目任务';
comment on column ${idl_schema}.iers_er_busitem.receiver is '收款人';
comment on column ${idl_schema}.iers_er_busitem.rowno is '行号';
comment on column ${idl_schema}.iers_er_busitem.sfcb is '是否超标';
comment on column ${idl_schema}.iers_er_busitem.skyhzh is '个人银行账户';
comment on column ${idl_schema}.iers_er_busitem.src_ybz_id is '友报账id';
comment on column ${idl_schema}.iers_er_busitem.srcbilltype is '来源单据类型';
comment on column ${idl_schema}.iers_er_busitem.srctype is '来源类型';
comment on column ${idl_schema}.iers_er_busitem.szxmid is '收支项目';
comment on column ${idl_schema}.iers_er_busitem.tablecode is '页签编码';
comment on column ${idl_schema}.iers_er_busitem.tax_amount is '税金金额';
comment on column ${idl_schema}.iers_er_busitem.tax_rate is '税率';
comment on column ${idl_schema}.iers_er_busitem.tni_amount is '不含税金额';
comment on column ${idl_schema}.iers_er_busitem.ts is '时间戳';
comment on column ${idl_schema}.iers_er_busitem.vat_amount is '含税金额';
comment on column ${idl_schema}.iers_er_busitem.ybje is '原币金额';
comment on column ${idl_schema}.iers_er_busitem.ybye is '原币余额';
comment on column ${idl_schema}.iers_er_busitem.yjye is '预计余额';
comment on column ${idl_schema}.iers_er_busitem.zfbbje is '支付本币金额';
comment on column ${idl_schema}.iers_er_busitem.zfybje is '支付金额';
comment on column ${idl_schema}.iers_er_busitem.fplxpk is '发票类型主键';
comment on column ${idl_schema}.iers_er_busitem.generatetype is '发票生成方式';
comment on column ${idl_schema}.iers_er_busitem.pk_erminvoice is '关联发票';
comment on column ${idl_schema}.iers_er_busitem.pk_erminvoice_b is '关联发票明细';
comment on column ${idl_schema}.iers_er_busitem.jxzcje is '进项转出金额';
comment on column ${idl_schema}.iers_er_busitem.stxsje is '视同销售金额';
comment on column ${idl_schema}.iers_er_busitem.qualitydeposit is '质保金';
comment on column ${idl_schema}.iers_er_busitem.pk_resource is '';
comment on column ${idl_schema}.iers_er_busitem.pk_resource_b is '单据来源子表主键';
comment on column ${idl_schema}.iers_er_busitem.remark is '备注2';
comment on column ${idl_schema}.iers_er_busitem.leavedate is '离开日期';
comment on column ${idl_schema}.iers_er_busitem.staydates is '停留日期';
comment on column ${idl_schema}.iers_er_busitem.bsarrive is '到达';
comment on column ${idl_schema}.iers_er_busitem.isconverd is '是否转换';
comment on column ${idl_schema}.iers_er_busitem.defitem_convert_reason is '事由';
comment on column ${idl_schema}.iers_er_busitem.asale_taxrate is '税率';
comment on column ${idl_schema}.iers_er_busitem.asale_vat_amount is '含税金额';
comment on column ${idl_schema}.iers_er_busitem.taxitem is '税收项目';
comment on column ${idl_schema}.iers_er_busitem.buytaxno is '购方税号';
comment on column ${idl_schema}.iers_er_busitem.traveldate is '旅行日期';
comment on column ${idl_schema}.iers_er_busitem.deductype is '演绎类型';
comment on column ${idl_schema}.iers_er_busitem.enddate is '结束日期';
comment on column ${idl_schema}.iers_er_busitem.arrivedate is '到达日期';
comment on column ${idl_schema}.iers_er_busitem.taxperiod is '税期';
comment on column ${idl_schema}.iers_er_busitem.converexplain is '自定义';
comment on column ${idl_schema}.iers_er_busitem.traffictools is '交通工具';
comment on column ${idl_schema}.iers_er_busitem.subsidycosts is '补贴成本';
comment on column ${idl_schema}.iers_er_busitem.standardcosts is '标准成本';
comment on column ${idl_schema}.iers_er_busitem.arrive is '到达';
comment on column ${idl_schema}.iers_er_busitem.defitem_asale_reason is '事由';
comment on column ${idl_schema}.iers_er_busitem.buyname is '买名';
comment on column ${idl_schema}.iers_er_busitem.leave is '离开';
comment on column ${idl_schema}.iers_er_busitem.asale_tni_amount is '不含税金额';
comment on column ${idl_schema}.iers_er_busitem.notes is '备注';
comment on column ${idl_schema}.iers_er_busitem.asale_explain is '解释';
comment on column ${idl_schema}.iers_er_busitem.convert_tax is '销项税';
comment on column ${idl_schema}.iers_er_busitem.input_tax is '进项税';
comment on column ${idl_schema}.iers_er_busitem.companyrealpay is '公司实付金额';
comment on column ${idl_schema}.iers_er_busitem.pk_trip_orderno is '指令状态';
comment on column ${idl_schema}.iers_er_busitem.asale_tax is '税';
comment on column ${idl_schema}.iers_er_busitem.isdeemedsale is '是否视同销售';
comment on column ${idl_schema}.iers_er_busitem.startdate is '开始日期';
comment on column ${idl_schema}.iers_er_busitem.defitem81 is '自定义项81';
comment on column ${idl_schema}.iers_er_busitem.defitem82 is '自定义项82';
comment on column ${idl_schema}.iers_er_busitem.defitem83 is '自定义项83';
comment on column ${idl_schema}.iers_er_busitem.defitem84 is '自定义项84';
comment on column ${idl_schema}.iers_er_busitem.defitem85 is '自定义项85';
comment on column ${idl_schema}.iers_er_busitem.defitem86 is '自定义项86';
comment on column ${idl_schema}.iers_er_busitem.defitem87 is '自定义项87';
comment on column ${idl_schema}.iers_er_busitem.defitem88 is '自定义项88';
comment on column ${idl_schema}.iers_er_busitem.defitem89 is '自定义项89';
comment on column ${idl_schema}.iers_er_busitem.defitem90 is '自定义项90';
comment on column ${idl_schema}.iers_er_busitem.defitem91 is '自定义项91';
comment on column ${idl_schema}.iers_er_busitem.defitem92 is '自定义项92';
comment on column ${idl_schema}.iers_er_busitem.defitem93 is '自定义项93';
comment on column ${idl_schema}.iers_er_busitem.defitem94 is '自定义项94';
comment on column ${idl_schema}.iers_er_busitem.defitem95 is '自定义项95';
comment on column ${idl_schema}.iers_er_busitem.defitem96 is '自定义项96';
comment on column ${idl_schema}.iers_er_busitem.defitem97 is '自定义项97';
comment on column ${idl_schema}.iers_er_busitem.defitem98 is '自定义项98';
comment on column ${idl_schema}.iers_er_busitem.defitem99 is '自定义项99';
comment on column ${idl_schema}.iers_er_busitem.defitem100 is '自定义项100';
comment on column ${idl_schema}.iers_er_busitem.defitem101 is '自定义项101';
comment on column ${idl_schema}.iers_er_busitem.defitem102 is '自定义项102';
comment on column ${idl_schema}.iers_er_busitem.defitem103 is '自定义项103';
comment on column ${idl_schema}.iers_er_busitem.defitem104 is '自定义项104';
comment on column ${idl_schema}.iers_er_busitem.defitem105 is '自定义项105';
comment on column ${idl_schema}.iers_er_busitem.defitem106 is '自定义项106';
comment on column ${idl_schema}.iers_er_busitem.defitem107 is '自定义项107';
comment on column ${idl_schema}.iers_er_busitem.defitem108 is '自定义项108';
comment on column ${idl_schema}.iers_er_busitem.defitem109 is '自定义项109';
comment on column ${idl_schema}.iers_er_busitem.defitem110 is '自定义项110';
comment on column ${idl_schema}.iers_er_busitem.defitem111 is '自定义项111';
comment on column ${idl_schema}.iers_er_busitem.defitem112 is '自定义项112';
comment on column ${idl_schema}.iers_er_busitem.defitem113 is '自定义项113';
comment on column ${idl_schema}.iers_er_busitem.defitem114 is '自定义项114';
comment on column ${idl_schema}.iers_er_busitem.defitem115 is '自定义项115';
comment on column ${idl_schema}.iers_er_busitem.defitem116 is '自定义项116';
comment on column ${idl_schema}.iers_er_busitem.defitem117 is '自定义项117';
comment on column ${idl_schema}.iers_er_busitem.defitem118 is '自定义项118';
comment on column ${idl_schema}.iers_er_busitem.defitem119 is '自定义项119';
comment on column ${idl_schema}.iers_er_busitem.defitem120 is '自定义项120';
comment on column ${idl_schema}.iers_er_busitem.defitem121 is '自定义项121';
comment on column ${idl_schema}.iers_er_busitem.defitem122 is '自定义项122';
comment on column ${idl_schema}.iers_er_busitem.defitem123 is '自定义项123';
comment on column ${idl_schema}.iers_er_busitem.defitem124 is '自定义项124';
comment on column ${idl_schema}.iers_er_busitem.defitem125 is '自定义项125';
comment on column ${idl_schema}.iers_er_busitem.defitem126 is '自定义项126';
comment on column ${idl_schema}.iers_er_busitem.defitem127 is '自定义项127';
comment on column ${idl_schema}.iers_er_busitem.defitem128 is '自定义项128';
comment on column ${idl_schema}.iers_er_busitem.defitem129 is '自定义项129';
comment on column ${idl_schema}.iers_er_busitem.defitem130 is '自定义项130';
comment on column ${idl_schema}.iers_er_busitem.defitem131 is '自定义项131';
comment on column ${idl_schema}.iers_er_busitem.defitem132 is '自定义项132';
comment on column ${idl_schema}.iers_er_busitem.defitem133 is '自定义项133';
comment on column ${idl_schema}.iers_er_busitem.defitem134 is '自定义项134';
comment on column ${idl_schema}.iers_er_busitem.defitem135 is '自定义项135';
comment on column ${idl_schema}.iers_er_busitem.defitem136 is '自定义项136';
comment on column ${idl_schema}.iers_er_busitem.defitem137 is '自定义项137';
comment on column ${idl_schema}.iers_er_busitem.defitem138 is '自定义项138';
comment on column ${idl_schema}.iers_er_busitem.defitem139 is '自定义项139';
comment on column ${idl_schema}.iers_er_busitem.defitem140 is '自定义项140';
comment on column ${idl_schema}.iers_er_busitem.defitem141 is '自定义项141';
comment on column ${idl_schema}.iers_er_busitem.defitem142 is '自定义项142';
comment on column ${idl_schema}.iers_er_busitem.defitem143 is '自定义项143';
comment on column ${idl_schema}.iers_er_busitem.defitem144 is '自定义项144';
comment on column ${idl_schema}.iers_er_busitem.defitem145 is '自定义项145';
comment on column ${idl_schema}.iers_er_busitem.defitem146 is '自定义项146';
comment on column ${idl_schema}.iers_er_busitem.defitem147 is '自定义项147';
comment on column ${idl_schema}.iers_er_busitem.defitem148 is '自定义项148';
comment on column ${idl_schema}.iers_er_busitem.defitem149 is '自定义项149';
comment on column ${idl_schema}.iers_er_busitem.defitem150 is '自定义项150';
comment on column ${idl_schema}.iers_er_busitem.defitem151 is '自定义项151';
comment on column ${idl_schema}.iers_er_busitem.defitem152 is '自定义项152';
comment on column ${idl_schema}.iers_er_busitem.defitem153 is '自定义项153';
comment on column ${idl_schema}.iers_er_busitem.defitem154 is '自定义项154';
comment on column ${idl_schema}.iers_er_busitem.defitem155 is '自定义项155';
comment on column ${idl_schema}.iers_er_busitem.defitem156 is '自定义项156';
comment on column ${idl_schema}.iers_er_busitem.defitem157 is '自定义项157';
comment on column ${idl_schema}.iers_er_busitem.defitem158 is '自定义项158';
comment on column ${idl_schema}.iers_er_busitem.defitem159 is '自定义项159';
comment on column ${idl_schema}.iers_er_busitem.defitem160 is '自定义项160';
comment on column ${idl_schema}.iers_er_busitem.start_dt is '开始时间';
comment on column ${idl_schema}.iers_er_busitem.end_dt is '结束时间';
comment on column ${idl_schema}.iers_er_busitem.id_mark is '增删标志';
comment on column ${idl_schema}.iers_er_busitem.etl_dt is 'ETL处理时间';


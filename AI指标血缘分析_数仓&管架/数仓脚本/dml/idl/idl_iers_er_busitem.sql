/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_iers_er_busitem
CreateDate: 20260309
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.iers_er_busitem drop partition p_${batch_date};

-- 2.1.1 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${idl_schema}.iers_er_busitem;

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.iers_er_busitem add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.iers_er_busitem (
amount  --金额
,bbhl  --本币汇率
,bbje  --本币金额
,bbye  --本币余额
,bzbm  --币种
,cjkbbje  --冲借款本币金额
,cjkybje  --冲借款金额
,companypaytype  --企业支付类型
,custaccount  --客商银行账户
,customer  --客户
,defitem1  --自定义项1
,defitem10  --自定义项10
,defitem11  --自定义项11
,defitem12  --自定义项12
,defitem13  --自定义项13
,defitem14  --自定义项14
,defitem15  --自定义项15
,defitem16  --自定义项16
,defitem17  --自定义项17
,defitem18  --自定义项18
,defitem19  --自定义项19
,defitem2  --自定义项2
,defitem20  --自定义项20
,defitem21  --自定义项21
,defitem22  --自定义项22
,defitem23  --自定义项23
,defitem24  --自定义项24
,defitem25  --自定义项25
,defitem26  --自定义项26
,defitem27  --自定义项27
,defitem28  --自定义项28
,defitem29  --自定义项29
,defitem3  --自定义项3
,defitem30  --自定义项30
,defitem31  --自定义项31
,defitem32  --自定义项32
,defitem33  --自定义项33
,defitem34  --自定义项34
,defitem35  --自定义项35
,defitem36  --自定义项36
,defitem37  --自定义项37
,defitem38  --自定义项38
,defitem39  --自定义项39
,defitem4  --自定义项4
,defitem40  --自定义项40
,defitem41  --自定义项41
,defitem42  --自定义项42
,defitem43  --自定义项43
,defitem44  --自定义项44
,defitem45  --自定义项45
,defitem46  --自定义项46
,defitem47  --自定义项47
,defitem48  --自定义项48
,defitem49  --自定义项49
,defitem5  --自定义项5
,defitem50  --自定义项50
,defitem51  --自定义项51
,defitem52  --自定义项52
,defitem53  --自定义项53
,defitem54  --自定义项54
,defitem55  --自定义项55
,defitem56  --自定义项56
,defitem57  --自定义项57
,defitem58  --自定义项58
,defitem59  --自定义项59
,defitem6  --自定义项6
,defitem60  --自定义项60
,defitem61  --自定义项61
,defitem62  --自定义项62
,defitem63  --自定义项63
,defitem64  --自定义项64
,defitem65  --自定义项65
,defitem66  --自定义项66
,defitem67  --自定义项67
,defitem68  --自定义项68
,defitem69  --自定义项69
,defitem7  --自定义项7
,defitem70  --自定义项70
,defitem71  --自定义项71
,defitem72  --自定义项72
,defitem73  --自定义项73
,defitem74  --自定义项74
,defitem75  --自定义项75
,defitem76  --自定义项76
,defitem77  --自定义项77
,defitem78  --自定义项78
,defitem79  --自定义项79
,defitem8  --自定义项8
,defitem80  --自定义项80
,defitem9  --自定义项9
,deptid  --报销人部门
,dr  --删除标志
,dwbm  --报销人单位
,fctno  --合同号
,fpdm  --发票代码
,fphm  --发票号码
,fplx  --发票类型
,freecust  --散户
,globalbbhl  --全局本币汇率
,globalbbje  --全局本币金额
,globalbbye  --全局本币余额
,globalcjkbbje  --全局冲借款本币金额
,globalhkbbje  --全局还款本币金额
,globaltax_amount  --全局税金本币金额
,globaltni_amount  --全局不含税本币金额
,globalvat_amount  --全局含税本币金额
,globalzfbbje  --全局支付本币金额
,groupbbhl  --集团本币汇率
,groupbbje  --集团本币金额
,groupbbye  --集团本币余额
,groupcjkbbje  --集团冲借款本币金额
,grouphkbbje  --集团还款本币金额
,grouptax_amount  --集团税金本币金额
,grouptni_amount  --集团不含税本币金额
,groupvat_amount  --集团含税本币金额
,groupzfbbje  --集团支付本币金额
,hbbm  --供应商
,hkbbje  --还款本币金额
,hkybje  --还款金额
,iscompanypay  --是否企业支付
,jkbxr  --报销人
,jobid  --项目
,jsfs  --结算方式
,orgtax_amount  --税金组织本币金额
,orgtni_amount  --不含税组织本位币金额
,orgvat_amount  --含税组织本位币金额
,paytarget  --收款对象
,pk_brand  --品牌
,pk_busitem  --报销单业务行标识
,pk_checkele  --核算要素
,pk_crmdetail  --pk_crm
,pk_fprelation  --关联发票
,pk_item  --费用申请单
,pk_jkbx  --报销单标识
,pk_mtapp_detail  --费用申请单明细
,pk_pcorg  --利润中心
,pk_pcorg_v  --利润中心历史版本
,pk_proline  --产品线
,pk_reimtype  --报销类型
,pk_resacostcenter  --成本中心
,projecttask  --项目任务
,receiver  --收款人
,rowno  --行号
,sfcb  --是否超标
,skyhzh  --个人银行账户
,src_ybz_id  --友报账id
,srcbilltype  --来源单据类型
,srctype  --来源类型
,szxmid  --收支项目
,tablecode  --页签编码
,tax_amount  --税金金额
,tax_rate  --税率
,tni_amount  --不含税金额
,ts  --时间戳
,vat_amount  --含税金额
,ybje  --原币金额
,ybye  --原币余额
,yjye  --预计余额
,zfbbje  --支付本币金额
,zfybje  --支付金额
,fplxpk  --发票类型主键
,generatetype  --发票生成方式
,pk_erminvoice  --关联发票
,pk_erminvoice_b  --关联发票明细
,jxzcje  --进项转出金额
,stxsje  --视同销售金额
,qualitydeposit  --质保金
,pk_resource  --
,pk_resource_b  --单据来源子表主键
,remark  --备注2
,leavedate  --离开日期
,staydates  --停留日期
,bsarrive  --到达
,isconverd  --是否转换
,defitem_convert_reason  --事由
,asale_taxrate  --税率
,asale_vat_amount  --含税金额
,taxitem  --税收项目
,buytaxno  --购方税号
,traveldate  --旅行日期
,deductype  --演绎类型
,enddate  --结束日期
,arrivedate  --到达日期
,taxperiod  --税期
,converexplain  --自定义
,traffictools  --交通工具
,subsidycosts  --补贴成本
,standardcosts  --标准成本
,arrive  --到达
,defitem_asale_reason  --事由
,buyname  --买名
,leave  --离开
,asale_tni_amount  --不含税金额
,notes  --备注
,asale_explain  --解释
,convert_tax  --销项税
,input_tax  --进项税
,companyrealpay  --公司实付金额
,pk_trip_orderno  --指令状态
,asale_tax  --税
,isdeemedsale  --是否视同销售
,startdate  --开始日期
,defitem81  --自定义项81
,defitem82  --自定义项82
,defitem83  --自定义项83
,defitem84  --自定义项84
,defitem85  --自定义项85
,defitem86  --自定义项86
,defitem87  --自定义项87
,defitem88  --自定义项88
,defitem89  --自定义项89
,defitem90  --自定义项90
,defitem91  --自定义项91
,defitem92  --自定义项92
,defitem93  --自定义项93
,defitem94  --自定义项94
,defitem95  --自定义项95
,defitem96  --自定义项96
,defitem97  --自定义项97
,defitem98  --自定义项98
,defitem99  --自定义项99
,defitem100  --自定义项100
,defitem101  --自定义项101
,defitem102  --自定义项102
,defitem103  --自定义项103
,defitem104  --自定义项104
,defitem105  --自定义项105
,defitem106  --自定义项106
,defitem107  --自定义项107
,defitem108  --自定义项108
,defitem109  --自定义项109
,defitem110  --自定义项110
,defitem111  --自定义项111
,defitem112  --自定义项112
,defitem113  --自定义项113
,defitem114  --自定义项114
,defitem115  --自定义项115
,defitem116  --自定义项116
,defitem117  --自定义项117
,defitem118  --自定义项118
,defitem119  --自定义项119
,defitem120  --自定义项120
,defitem121  --自定义项121
,defitem122  --自定义项122
,defitem123  --自定义项123
,defitem124  --自定义项124
,defitem125  --自定义项125
,defitem126  --自定义项126
,defitem127  --自定义项127
,defitem128  --自定义项128
,defitem129  --自定义项129
,defitem130  --自定义项130
,defitem131  --自定义项131
,defitem132  --自定义项132
,defitem133  --自定义项133
,defitem134  --自定义项134
,defitem135  --自定义项135
,defitem136  --自定义项136
,defitem137  --自定义项137
,defitem138  --自定义项138
,defitem139  --自定义项139
,defitem140  --自定义项140
,defitem141  --自定义项141
,defitem142  --自定义项142
,defitem143  --自定义项143
,defitem144  --自定义项144
,defitem145  --自定义项145
,defitem146  --自定义项146
,defitem147  --自定义项147
,defitem148  --自定义项148
,defitem149  --自定义项149
,defitem150  --自定义项150
,defitem151  --自定义项151
,defitem152  --自定义项152
,defitem153  --自定义项153
,defitem154  --自定义项154
,defitem155  --自定义项155
,defitem156  --自定义项156
,defitem157  --自定义项157
,defitem158  --自定义项158
,defitem159  --自定义项159
,defitem160  --自定义项160
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,etl_dt  --ETL处理时间

)
select
t1.amount as amount --金额
,t1.bbhl as bbhl --本币汇率
,t1.bbje as bbje --本币金额
,t1.bbye as bbye --本币余额
,replace(replace(t1.bzbm,chr(13),''),chr(10),'') as bzbm --币种
,t1.cjkbbje as cjkbbje --冲借款本币金额
,t1.cjkybje as cjkybje --冲借款金额
,replace(replace(t1.companypaytype,chr(13),''),chr(10),'') as companypaytype --企业支付类型
,replace(replace(t1.custaccount,chr(13),''),chr(10),'') as custaccount --客商银行账户
,replace(replace(t1.customer,chr(13),''),chr(10),'') as customer --客户
,replace(replace(t1.defitem1,chr(13),''),chr(10),'') as defitem1 --自定义项1
,replace(replace(t1.defitem10,chr(13),''),chr(10),'') as defitem10 --自定义项10
,replace(replace(t1.defitem11,chr(13),''),chr(10),'') as defitem11 --自定义项11
,replace(replace(t1.defitem12,chr(13),''),chr(10),'') as defitem12 --自定义项12
,replace(replace(t1.defitem13,chr(13),''),chr(10),'') as defitem13 --自定义项13
,replace(replace(t1.defitem14,chr(13),''),chr(10),'') as defitem14 --自定义项14
,replace(replace(t1.defitem15,chr(13),''),chr(10),'') as defitem15 --自定义项15
,replace(replace(t1.defitem16,chr(13),''),chr(10),'') as defitem16 --自定义项16
,replace(replace(t1.defitem17,chr(13),''),chr(10),'') as defitem17 --自定义项17
,replace(replace(t1.defitem18,chr(13),''),chr(10),'') as defitem18 --自定义项18
,replace(replace(t1.defitem19,chr(13),''),chr(10),'') as defitem19 --自定义项19
,replace(replace(t1.defitem2,chr(13),''),chr(10),'') as defitem2 --自定义项2
,replace(replace(t1.defitem20,chr(13),''),chr(10),'') as defitem20 --自定义项20
,replace(replace(t1.defitem21,chr(13),''),chr(10),'') as defitem21 --自定义项21
,replace(replace(t1.defitem22,chr(13),''),chr(10),'') as defitem22 --自定义项22
,replace(replace(t1.defitem23,chr(13),''),chr(10),'') as defitem23 --自定义项23
,replace(replace(t1.defitem24,chr(13),''),chr(10),'') as defitem24 --自定义项24
,replace(replace(t1.defitem25,chr(13),''),chr(10),'') as defitem25 --自定义项25
,replace(replace(t1.defitem26,chr(13),''),chr(10),'') as defitem26 --自定义项26
,replace(replace(t1.defitem27,chr(13),''),chr(10),'') as defitem27 --自定义项27
,replace(replace(t1.defitem28,chr(13),''),chr(10),'') as defitem28 --自定义项28
,replace(replace(t1.defitem29,chr(13),''),chr(10),'') as defitem29 --自定义项29
,replace(replace(t1.defitem3,chr(13),''),chr(10),'') as defitem3 --自定义项3
,replace(replace(t1.defitem30,chr(13),''),chr(10),'') as defitem30 --自定义项30
,replace(replace(t1.defitem31,chr(13),''),chr(10),'') as defitem31 --自定义项31
,replace(replace(t1.defitem32,chr(13),''),chr(10),'') as defitem32 --自定义项32
,replace(replace(t1.defitem33,chr(13),''),chr(10),'') as defitem33 --自定义项33
,replace(replace(t1.defitem34,chr(13),''),chr(10),'') as defitem34 --自定义项34
,replace(replace(t1.defitem35,chr(13),''),chr(10),'') as defitem35 --自定义项35
,replace(replace(t1.defitem36,chr(13),''),chr(10),'') as defitem36 --自定义项36
,replace(replace(t1.defitem37,chr(13),''),chr(10),'') as defitem37 --自定义项37
,replace(replace(t1.defitem38,chr(13),''),chr(10),'') as defitem38 --自定义项38
,replace(replace(t1.defitem39,chr(13),''),chr(10),'') as defitem39 --自定义项39
,replace(replace(t1.defitem4,chr(13),''),chr(10),'') as defitem4 --自定义项4
,replace(replace(t1.defitem40,chr(13),''),chr(10),'') as defitem40 --自定义项40
,replace(replace(t1.defitem41,chr(13),''),chr(10),'') as defitem41 --自定义项41
,replace(replace(t1.defitem42,chr(13),''),chr(10),'') as defitem42 --自定义项42
,replace(replace(t1.defitem43,chr(13),''),chr(10),'') as defitem43 --自定义项43
,replace(replace(t1.defitem44,chr(13),''),chr(10),'') as defitem44 --自定义项44
,replace(replace(t1.defitem45,chr(13),''),chr(10),'') as defitem45 --自定义项45
,replace(replace(t1.defitem46,chr(13),''),chr(10),'') as defitem46 --自定义项46
,replace(replace(t1.defitem47,chr(13),''),chr(10),'') as defitem47 --自定义项47
,replace(replace(t1.defitem48,chr(13),''),chr(10),'') as defitem48 --自定义项48
,replace(replace(t1.defitem49,chr(13),''),chr(10),'') as defitem49 --自定义项49
,replace(replace(t1.defitem5,chr(13),''),chr(10),'') as defitem5 --自定义项5
,replace(replace(t1.defitem50,chr(13),''),chr(10),'') as defitem50 --自定义项50
,replace(replace(t1.defitem51,chr(13),''),chr(10),'') as defitem51 --自定义项51
,replace(replace(t1.defitem52,chr(13),''),chr(10),'') as defitem52 --自定义项52
,replace(replace(t1.defitem53,chr(13),''),chr(10),'') as defitem53 --自定义项53
,replace(replace(t1.defitem54,chr(13),''),chr(10),'') as defitem54 --自定义项54
,replace(replace(t1.defitem55,chr(13),''),chr(10),'') as defitem55 --自定义项55
,replace(replace(t1.defitem56,chr(13),''),chr(10),'') as defitem56 --自定义项56
,replace(replace(t1.defitem57,chr(13),''),chr(10),'') as defitem57 --自定义项57
,replace(replace(t1.defitem58,chr(13),''),chr(10),'') as defitem58 --自定义项58
,replace(replace(t1.defitem59,chr(13),''),chr(10),'') as defitem59 --自定义项59
,replace(replace(t1.defitem6,chr(13),''),chr(10),'') as defitem6 --自定义项6
,replace(replace(t1.defitem60,chr(13),''),chr(10),'') as defitem60 --自定义项60
,replace(replace(t1.defitem61,chr(13),''),chr(10),'') as defitem61 --自定义项61
,replace(replace(t1.defitem62,chr(13),''),chr(10),'') as defitem62 --自定义项62
,replace(replace(t1.defitem63,chr(13),''),chr(10),'') as defitem63 --自定义项63
,replace(replace(t1.defitem64,chr(13),''),chr(10),'') as defitem64 --自定义项64
,replace(replace(t1.defitem65,chr(13),''),chr(10),'') as defitem65 --自定义项65
,replace(replace(t1.defitem66,chr(13),''),chr(10),'') as defitem66 --自定义项66
,replace(replace(t1.defitem67,chr(13),''),chr(10),'') as defitem67 --自定义项67
,replace(replace(t1.defitem68,chr(13),''),chr(10),'') as defitem68 --自定义项68
,replace(replace(t1.defitem69,chr(13),''),chr(10),'') as defitem69 --自定义项69
,replace(replace(t1.defitem7,chr(13),''),chr(10),'') as defitem7 --自定义项7
,replace(replace(t1.defitem70,chr(13),''),chr(10),'') as defitem70 --自定义项70
,replace(replace(t1.defitem71,chr(13),''),chr(10),'') as defitem71 --自定义项71
,replace(replace(t1.defitem72,chr(13),''),chr(10),'') as defitem72 --自定义项72
,replace(replace(t1.defitem73,chr(13),''),chr(10),'') as defitem73 --自定义项73
,replace(replace(t1.defitem74,chr(13),''),chr(10),'') as defitem74 --自定义项74
,replace(replace(t1.defitem75,chr(13),''),chr(10),'') as defitem75 --自定义项75
,replace(replace(t1.defitem76,chr(13),''),chr(10),'') as defitem76 --自定义项76
,replace(replace(t1.defitem77,chr(13),''),chr(10),'') as defitem77 --自定义项77
,replace(replace(t1.defitem78,chr(13),''),chr(10),'') as defitem78 --自定义项78
,replace(replace(t1.defitem79,chr(13),''),chr(10),'') as defitem79 --自定义项79
,replace(replace(t1.defitem8,chr(13),''),chr(10),'') as defitem8 --自定义项8
,replace(replace(t1.defitem80,chr(13),''),chr(10),'') as defitem80 --自定义项80
,replace(replace(t1.defitem9,chr(13),''),chr(10),'') as defitem9 --自定义项9
,replace(replace(t1.deptid,chr(13),''),chr(10),'') as deptid --报销人部门
,t1.dr as dr --删除标志
,replace(replace(t1.dwbm,chr(13),''),chr(10),'') as dwbm --报销人单位
,replace(replace(t1.fctno,chr(13),''),chr(10),'') as fctno --合同号
,replace(replace(t1.fpdm,chr(13),''),chr(10),'') as fpdm --发票代码
,replace(replace(t1.fphm,chr(13),''),chr(10),'') as fphm --发票号码
,replace(replace(t1.fplx,chr(13),''),chr(10),'') as fplx --发票类型
,replace(replace(t1.freecust,chr(13),''),chr(10),'') as freecust --散户
,t1.globalbbhl as globalbbhl --全局本币汇率
,t1.globalbbje as globalbbje --全局本币金额
,t1.globalbbye as globalbbye --全局本币余额
,t1.globalcjkbbje as globalcjkbbje --全局冲借款本币金额
,t1.globalhkbbje as globalhkbbje --全局还款本币金额
,t1.globaltax_amount as globaltax_amount --全局税金本币金额
,t1.globaltni_amount as globaltni_amount --全局不含税本币金额
,t1.globalvat_amount as globalvat_amount --全局含税本币金额
,t1.globalzfbbje as globalzfbbje --全局支付本币金额
,t1.groupbbhl as groupbbhl --集团本币汇率
,t1.groupbbje as groupbbje --集团本币金额
,t1.groupbbye as groupbbye --集团本币余额
,t1.groupcjkbbje as groupcjkbbje --集团冲借款本币金额
,t1.grouphkbbje as grouphkbbje --集团还款本币金额
,t1.grouptax_amount as grouptax_amount --集团税金本币金额
,t1.grouptni_amount as grouptni_amount --集团不含税本币金额
,t1.groupvat_amount as groupvat_amount --集团含税本币金额
,t1.groupzfbbje as groupzfbbje --集团支付本币金额
,replace(replace(t1.hbbm,chr(13),''),chr(10),'') as hbbm --供应商
,t1.hkbbje as hkbbje --还款本币金额
,t1.hkybje as hkybje --还款金额
,replace(replace(t1.iscompanypay,chr(13),''),chr(10),'') as iscompanypay --是否企业支付
,replace(replace(t1.jkbxr,chr(13),''),chr(10),'') as jkbxr --报销人
,replace(replace(t1.jobid,chr(13),''),chr(10),'') as jobid --项目
,replace(replace(t1.jsfs,chr(13),''),chr(10),'') as jsfs --结算方式
,t1.orgtax_amount as orgtax_amount --税金组织本币金额
,t1.orgtni_amount as orgtni_amount --不含税组织本位币金额
,t1.orgvat_amount as orgvat_amount --含税组织本位币金额
,t1.paytarget as paytarget --收款对象
,replace(replace(t1.pk_brand,chr(13),''),chr(10),'') as pk_brand --品牌
,replace(replace(t1.pk_busitem,chr(13),''),chr(10),'') as pk_busitem --报销单业务行标识
,replace(replace(t1.pk_checkele,chr(13),''),chr(10),'') as pk_checkele --核算要素
,replace(replace(t1.pk_crmdetail,chr(13),''),chr(10),'') as pk_crmdetail --pk_crm
,replace(replace(t1.pk_fprelation,chr(13),''),chr(10),'') as pk_fprelation --关联发票
,replace(replace(t1.pk_item,chr(13),''),chr(10),'') as pk_item --费用申请单
,replace(replace(t1.pk_jkbx,chr(13),''),chr(10),'') as pk_jkbx --报销单标识
,replace(replace(t1.pk_mtapp_detail,chr(13),''),chr(10),'') as pk_mtapp_detail --费用申请单明细
,replace(replace(t1.pk_pcorg,chr(13),''),chr(10),'') as pk_pcorg --利润中心
,replace(replace(t1.pk_pcorg_v,chr(13),''),chr(10),'') as pk_pcorg_v --利润中心历史版本
,replace(replace(t1.pk_proline,chr(13),''),chr(10),'') as pk_proline --产品线
,replace(replace(t1.pk_reimtype,chr(13),''),chr(10),'') as pk_reimtype --报销类型
,replace(replace(t1.pk_resacostcenter,chr(13),''),chr(10),'') as pk_resacostcenter --成本中心
,replace(replace(t1.projecttask,chr(13),''),chr(10),'') as projecttask --项目任务
,replace(replace(t1.receiver,chr(13),''),chr(10),'') as receiver --收款人
,t1.rowno as rowno --行号
,replace(replace(t1.sfcb,chr(13),''),chr(10),'') as sfcb --是否超标
,replace(replace(t1.skyhzh,chr(13),''),chr(10),'') as skyhzh --个人银行账户
,replace(replace(t1.src_ybz_id,chr(13),''),chr(10),'') as src_ybz_id --友报账id
,replace(replace(t1.srcbilltype,chr(13),''),chr(10),'') as srcbilltype --来源单据类型
,replace(replace(t1.srctype,chr(13),''),chr(10),'') as srctype --来源类型
,replace(replace(t1.szxmid,chr(13),''),chr(10),'') as szxmid --收支项目
,replace(replace(t1.tablecode,chr(13),''),chr(10),'') as tablecode --页签编码
,t1.tax_amount as tax_amount --税金金额
,t1.tax_rate as tax_rate --税率
,t1.tni_amount as tni_amount --不含税金额
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts --时间戳
,t1.vat_amount as vat_amount --含税金额
,t1.ybje as ybje --原币金额
,t1.ybye as ybye --原币余额
,t1.yjye as yjye --预计余额
,t1.zfbbje as zfbbje --支付本币金额
,t1.zfybje as zfybje --支付金额
,replace(replace(t1.fplxpk,chr(13),''),chr(10),'') as fplxpk --发票类型主键
,replace(replace(t1.generatetype,chr(13),''),chr(10),'') as generatetype --发票生成方式
,replace(replace(t1.pk_erminvoice,chr(13),''),chr(10),'') as pk_erminvoice --关联发票
,replace(replace(t1.pk_erminvoice_b,chr(13),''),chr(10),'') as pk_erminvoice_b --关联发票明细
,t1.jxzcje as jxzcje --进项转出金额
,t1.stxsje as stxsje --视同销售金额
,t1.qualitydeposit as qualitydeposit --质保金
,replace(replace(t1.pk_resource,chr(13),''),chr(10),'') as pk_resource --
,replace(replace(t1.pk_resource_b,chr(13),''),chr(10),'') as pk_resource_b --单据来源子表主键
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注2
,replace(replace(t1.leavedate,chr(13),''),chr(10),'') as leavedate --离开日期
,t1.staydates as staydates --停留日期
,replace(replace(t1.bsarrive,chr(13),''),chr(10),'') as bsarrive --到达
,t1.isconverd as isconverd --是否转换
,replace(replace(t1.defitem_convert_reason,chr(13),''),chr(10),'') as defitem_convert_reason --事由
,t1.asale_taxrate as asale_taxrate --税率
,t1.asale_vat_amount as asale_vat_amount --含税金额
,replace(replace(t1.taxitem,chr(13),''),chr(10),'') as taxitem --税收项目
,replace(replace(t1.buytaxno,chr(13),''),chr(10),'') as buytaxno --购方税号
,replace(replace(t1.traveldate,chr(13),''),chr(10),'') as traveldate --旅行日期
,t1.deductype as deductype --演绎类型
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate --结束日期
,replace(replace(t1.arrivedate,chr(13),''),chr(10),'') as arrivedate --到达日期
,replace(replace(t1.taxperiod,chr(13),''),chr(10),'') as taxperiod --税期
,replace(replace(t1.converexplain,chr(13),''),chr(10),'') as converexplain --自定义
,replace(replace(t1.traffictools,chr(13),''),chr(10),'') as traffictools --交通工具
,t1.subsidycosts as subsidycosts --补贴成本
,t1.standardcosts as standardcosts --标准成本
,replace(replace(t1.arrive,chr(13),''),chr(10),'') as arrive --到达
,replace(replace(t1.defitem_asale_reason,chr(13),''),chr(10),'') as defitem_asale_reason --事由
,replace(replace(t1.buyname,chr(13),''),chr(10),'') as buyname --买名
,replace(replace(t1.leave,chr(13),''),chr(10),'') as leave --离开
,t1.asale_tni_amount as asale_tni_amount --不含税金额
,replace(replace(t1.notes,chr(13),''),chr(10),'') as notes --备注
,replace(replace(t1.asale_explain,chr(13),''),chr(10),'') as asale_explain --解释
,t1.convert_tax as convert_tax --销项税
,t1.input_tax as input_tax --进项税
,t1.companyrealpay as companyrealpay --公司实付金额
,replace(replace(t1.pk_trip_orderno,chr(13),''),chr(10),'') as pk_trip_orderno --指令状态
,t1.asale_tax as asale_tax --税
,t1.isdeemedsale as isdeemedsale --是否视同销售
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate --开始日期
,replace(replace(t1.defitem81,chr(13),''),chr(10),'') as defitem81 --自定义项81
,replace(replace(t1.defitem82,chr(13),''),chr(10),'') as defitem82 --自定义项82
,replace(replace(t1.defitem83,chr(13),''),chr(10),'') as defitem83 --自定义项83
,replace(replace(t1.defitem84,chr(13),''),chr(10),'') as defitem84 --自定义项84
,replace(replace(t1.defitem85,chr(13),''),chr(10),'') as defitem85 --自定义项85
,replace(replace(t1.defitem86,chr(13),''),chr(10),'') as defitem86 --自定义项86
,replace(replace(t1.defitem87,chr(13),''),chr(10),'') as defitem87 --自定义项87
,replace(replace(t1.defitem88,chr(13),''),chr(10),'') as defitem88 --自定义项88
,replace(replace(t1.defitem89,chr(13),''),chr(10),'') as defitem89 --自定义项89
,replace(replace(t1.defitem90,chr(13),''),chr(10),'') as defitem90 --自定义项90
,replace(replace(t1.defitem91,chr(13),''),chr(10),'') as defitem91 --自定义项91
,replace(replace(t1.defitem92,chr(13),''),chr(10),'') as defitem92 --自定义项92
,replace(replace(t1.defitem93,chr(13),''),chr(10),'') as defitem93 --自定义项93
,replace(replace(t1.defitem94,chr(13),''),chr(10),'') as defitem94 --自定义项94
,replace(replace(t1.defitem95,chr(13),''),chr(10),'') as defitem95 --自定义项95
,replace(replace(t1.defitem96,chr(13),''),chr(10),'') as defitem96 --自定义项96
,replace(replace(t1.defitem97,chr(13),''),chr(10),'') as defitem97 --自定义项97
,replace(replace(t1.defitem98,chr(13),''),chr(10),'') as defitem98 --自定义项98
,replace(replace(t1.defitem99,chr(13),''),chr(10),'') as defitem99 --自定义项99
,replace(replace(t1.defitem100,chr(13),''),chr(10),'') as defitem100 --自定义项100
,replace(replace(t1.defitem101,chr(13),''),chr(10),'') as defitem101 --自定义项101
,replace(replace(t1.defitem102,chr(13),''),chr(10),'') as defitem102 --自定义项102
,replace(replace(t1.defitem103,chr(13),''),chr(10),'') as defitem103 --自定义项103
,replace(replace(t1.defitem104,chr(13),''),chr(10),'') as defitem104 --自定义项104
,replace(replace(t1.defitem105,chr(13),''),chr(10),'') as defitem105 --自定义项105
,replace(replace(t1.defitem106,chr(13),''),chr(10),'') as defitem106 --自定义项106
,replace(replace(t1.defitem107,chr(13),''),chr(10),'') as defitem107 --自定义项107
,replace(replace(t1.defitem108,chr(13),''),chr(10),'') as defitem108 --自定义项108
,replace(replace(t1.defitem109,chr(13),''),chr(10),'') as defitem109 --自定义项109
,replace(replace(t1.defitem110,chr(13),''),chr(10),'') as defitem110 --自定义项110
,replace(replace(t1.defitem111,chr(13),''),chr(10),'') as defitem111 --自定义项111
,replace(replace(t1.defitem112,chr(13),''),chr(10),'') as defitem112 --自定义项112
,replace(replace(t1.defitem113,chr(13),''),chr(10),'') as defitem113 --自定义项113
,replace(replace(t1.defitem114,chr(13),''),chr(10),'') as defitem114 --自定义项114
,replace(replace(t1.defitem115,chr(13),''),chr(10),'') as defitem115 --自定义项115
,replace(replace(t1.defitem116,chr(13),''),chr(10),'') as defitem116 --自定义项116
,replace(replace(t1.defitem117,chr(13),''),chr(10),'') as defitem117 --自定义项117
,replace(replace(t1.defitem118,chr(13),''),chr(10),'') as defitem118 --自定义项118
,replace(replace(t1.defitem119,chr(13),''),chr(10),'') as defitem119 --自定义项119
,replace(replace(t1.defitem120,chr(13),''),chr(10),'') as defitem120 --自定义项120
,replace(replace(t1.defitem121,chr(13),''),chr(10),'') as defitem121 --自定义项121
,replace(replace(t1.defitem122,chr(13),''),chr(10),'') as defitem122 --自定义项122
,replace(replace(t1.defitem123,chr(13),''),chr(10),'') as defitem123 --自定义项123
,replace(replace(t1.defitem124,chr(13),''),chr(10),'') as defitem124 --自定义项124
,replace(replace(t1.defitem125,chr(13),''),chr(10),'') as defitem125 --自定义项125
,replace(replace(t1.defitem126,chr(13),''),chr(10),'') as defitem126 --自定义项126
,replace(replace(t1.defitem127,chr(13),''),chr(10),'') as defitem127 --自定义项127
,replace(replace(t1.defitem128,chr(13),''),chr(10),'') as defitem128 --自定义项128
,replace(replace(t1.defitem129,chr(13),''),chr(10),'') as defitem129 --自定义项129
,replace(replace(t1.defitem130,chr(13),''),chr(10),'') as defitem130 --自定义项130
,replace(replace(t1.defitem131,chr(13),''),chr(10),'') as defitem131 --自定义项131
,replace(replace(t1.defitem132,chr(13),''),chr(10),'') as defitem132 --自定义项132
,replace(replace(t1.defitem133,chr(13),''),chr(10),'') as defitem133 --自定义项133
,replace(replace(t1.defitem134,chr(13),''),chr(10),'') as defitem134 --自定义项134
,replace(replace(t1.defitem135,chr(13),''),chr(10),'') as defitem135 --自定义项135
,replace(replace(t1.defitem136,chr(13),''),chr(10),'') as defitem136 --自定义项136
,replace(replace(t1.defitem137,chr(13),''),chr(10),'') as defitem137 --自定义项137
,replace(replace(t1.defitem138,chr(13),''),chr(10),'') as defitem138 --自定义项138
,replace(replace(t1.defitem139,chr(13),''),chr(10),'') as defitem139 --自定义项139
,replace(replace(t1.defitem140,chr(13),''),chr(10),'') as defitem140 --自定义项140
,replace(replace(t1.defitem141,chr(13),''),chr(10),'') as defitem141 --自定义项141
,replace(replace(t1.defitem142,chr(13),''),chr(10),'') as defitem142 --自定义项142
,replace(replace(t1.defitem143,chr(13),''),chr(10),'') as defitem143 --自定义项143
,replace(replace(t1.defitem144,chr(13),''),chr(10),'') as defitem144 --自定义项144
,replace(replace(t1.defitem145,chr(13),''),chr(10),'') as defitem145 --自定义项145
,replace(replace(t1.defitem146,chr(13),''),chr(10),'') as defitem146 --自定义项146
,replace(replace(t1.defitem147,chr(13),''),chr(10),'') as defitem147 --自定义项147
,replace(replace(t1.defitem148,chr(13),''),chr(10),'') as defitem148 --自定义项148
,replace(replace(t1.defitem149,chr(13),''),chr(10),'') as defitem149 --自定义项149
,replace(replace(t1.defitem150,chr(13),''),chr(10),'') as defitem150 --自定义项150
,replace(replace(t1.defitem151,chr(13),''),chr(10),'') as defitem151 --自定义项151
,replace(replace(t1.defitem152,chr(13),''),chr(10),'') as defitem152 --自定义项152
,replace(replace(t1.defitem153,chr(13),''),chr(10),'') as defitem153 --自定义项153
,replace(replace(t1.defitem154,chr(13),''),chr(10),'') as defitem154 --自定义项154
,replace(replace(t1.defitem155,chr(13),''),chr(10),'') as defitem155 --自定义项155
,replace(replace(t1.defitem156,chr(13),''),chr(10),'') as defitem156 --自定义项156
,replace(replace(t1.defitem157,chr(13),''),chr(10),'') as defitem157 --自定义项157
,replace(replace(t1.defitem158,chr(13),''),chr(10),'') as defitem158 --自定义项158
,replace(replace(t1.defitem159,chr(13),''),chr(10),'') as defitem159 --自定义项159
,replace(replace(t1.defitem160,chr(13),''),chr(10),'') as defitem160 --自定义项160
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理时间戳
from ${iol_schema}.iers_er_busitem t1
where 1=1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'iers_er_busitem',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

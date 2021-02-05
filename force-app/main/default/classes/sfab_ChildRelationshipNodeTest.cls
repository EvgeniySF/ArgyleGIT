/*
MIT License

Copyright (c) 2017 Matt Addy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
@isTest
private class sfab_ChildRelationshipNodeTest {
    @isTest
    private static void build_expectSerializeInvokedOnChildren() {
        sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObjectStub(Account.class);
        sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObjectStub(Account.class);
        sfab_ChildRelationshipNode node = new sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject> { child1, child2 });

        node.serialize();

        System.assert(child1.serializeInvoked);
        System.assert(child2.serializeInvoked);
    }

    @isTest
    private static void build_expectDoneMapKey() {
        sfab_ChildRelationshipNode node = new sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject>());

        Map<String, Object> builtNode = node.serialize();

        System.assert(((Map<String, Object>)builtNode.get('Accounts__r')).containsKey('done'));
        System.assert((Boolean)((Map<String, Object>)builtNode.get('Accounts__r')).get('done'));
    }

    @isTest
    private static void build_expectTotalSizeMapKey() {
        sfab_ChildRelationshipNode node = new sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObjectStub> {
                new sfab_FabricatedSObjectStub(Account.class),
                new sfab_FabricatedSObjectStub(Account.class)
        });

        Map<String, Object> builtNode = node.serialize();

        System.assert(((Map<String, Object>)builtNode.get('Accounts__r')).containsKey('totalSize'));
        System.assertEquals(2, ((Map<String, Object>)builtNode.get('Accounts__r')).get('totalSize'));
    }

    @isTest
    private static void build_expectSerializedChildrenMap() {
        sfab_FabricatedSObjectStub child1 = new sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-1' });
        sfab_FabricatedSObjectStub child2 = new sfab_FabricatedSObjectStub(Account.class, new Map<String, Object> { 'Name' => 'Foo-2' });
        sfab_ChildRelationshipNode node = new sfab_ChildRelationshipNode('Accounts__r', new List<sfab_FabricatedSObject> { child1, child2 });

        List<Map<String, Object>> serializedChildren = new List<Map<String, Object>>();
        serializedChildren.add(child1.serialize());
        serializedChildren.add(child2.serialize());

        Map<String, Object> builtNode = node.serialize();

        System.assertEquals(serializedChildren, ((Map<String, Object>)builtNode.get('Accounts__r')).get('records'));
    }
}